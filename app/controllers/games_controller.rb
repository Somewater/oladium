class GamesController < ApplicationController

  GAMES_PER_PAGE = 12
  GET_PATTERN = /net-(?<net>.+)-id-(?<id>.+)\?q=(?<query>.+)/
  GAMES_ORDER = ['priority DESC','(CASE WHEN (votings = 0) THEN 0 ELSE votes / votings END) DESC', 'usage DESC', 'created_at DESC']

  def index
    assign_page()
    @games = GameCache.fetch(scope, 'games', @page)
    if(@games.count > 15)
      primary_quantity = 3
      primary_quantity = 6 if @games.count > 30
      primary_quantity = 9 if @games.count > 50
      primary_quantity = 12 if @games.count > 100
      @primary_games = GameCache.fetch(primary_scope, 'primary_games', 0, primary_quantity)
    end
    render :template => 'games/index'
  end

  def show
    begin
      @game = Game.find_by_slug(params[:id]) || Game.find_by_id(params[:id]) || (raise ActiveRecord::RecordNotFound)
    rescue ActiveRecord::RecordNotFound
      match = params[:id] ? params[:id].to_s.match(GET_PATTERN) : nil
      if !@game && match
        net = match[:net]
        net_id = match[:id]
        a = Aggregator.send(net.to_sym)
        a.load(JSON.load(match[:query]).symbolize_keys)
        @game = a.games.map{|g| g.to_game}.find{|g| g.net == net && g.net_id == net_id}
      end
    end

    unless @game
      flash.now.alert = I18n.t('games.not_found')
      render 'main_page/not_found'
      return
    end

    unless current_user || current_developer
      @game.usage += 1
      @game.save unless @game.new_record?
    end
  end

  private
  def scope
    Game.order(*GAMES_ORDER)
  end

  def primary_scope
    Game.order(*(['"primary" DESC'].append GAMES_ORDER))
  end
end
