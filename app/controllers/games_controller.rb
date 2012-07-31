class GamesController < ApplicationController
  def index
    raise "fatal error: not implemented"
  end

  def show
    @game = Game.find(params[:id])
  end
end