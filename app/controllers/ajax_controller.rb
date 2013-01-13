class AjaxController < ApplicationController
  def rate
    game_id = params[:game].to_i
    score = params[:score].to_i
    raise "Wrong score range" unless (1..5).include? score
    game = Game.find(game_id)
    game.votes += score
    game.votings += 1
    game.save
    render :nothing => true
  end
end