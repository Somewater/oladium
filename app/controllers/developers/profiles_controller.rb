# encoding: utf-8

class Developers::ProfilesController < ApplicationController
  before_filter :authenticate_developer!

  def index
    if params['uploaded_game'] && params['game_id'].to_i > 0
      game = current_developer.games.find(params['game_id'])
      uploaded_io = params['uploaded_game']
      new_filename = GameUtils.filepath_to_next_version_filename game.body
      new_filepath = File.join(File.dirname(game.local_path), new_filename)
      File.open(new_filepath, 'wb'){|f| f.write(uploaded_io.read)}
      game.local_path = new_filepath
      game.save
      flash.notice = "New version of your game '#{game.title}' uploaded!"
    end
  end
end
