class MainPageController < ApplicationController
  def index
    @games = Game.all
    render :template => 'games/index'
  end

  def not_found
    render :text => 'Page not found'
  end
end
