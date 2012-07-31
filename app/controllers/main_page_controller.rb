class MainPageController < ApplicationController
  def index
    @games = Game.all
  end

  def not_found
    render :text => 'Page not found'
  end
end
