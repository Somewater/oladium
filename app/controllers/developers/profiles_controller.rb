# encoding: utf-8

class Developers::ProfilesController < ApplicationController
  before_filter :authenticate_developer!

  def index
    if params['uploaded_game'] && params['game_id'].to_i > 0
      game = current_developer.games.find(params['game_id'])
      uploaded_io = params['uploaded_game']
      new_filepath = File.join(Rails.root, 'public', 'games', File.dirname(game.body), 'main_2.swf')
      File.open(new_filepath, 'wb'){|f| f.write(uploaded_io.read)}
      game.update_column :body, File.join(File.dirname(game.body), 'main_2.swf')
      flash.notice = "New version of your game '#{game.title}' uploaded!"
    end
  end
end