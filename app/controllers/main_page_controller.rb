class MainPageController < ApplicationController
  def index
    a = Aggregator.mochi
    a.load
    @games = a.games.map{|g| g.to_game}
  end

  def not_found
    render :text => 'Page not found'
  end
end
