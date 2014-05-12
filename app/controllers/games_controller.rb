class GamesController < ApplicationController

  GAMES_PER_PAGE = 12
  GET_PATTERN = /net-(?<net>.+)-id-(?<id>.+)\?q=(?<query>.+)/
  GAMES_ORDER = ['priority DESC','(CASE WHEN (votings = 0) THEN 0 ELSE votes / votings END) DESC', 'usage DESC', 'created_at DESC']
  PRIMARY_GAMES_COUNT = 12

  before_filter :authenticate_user!, :only => ['update']

  def index
    assign_page()
    @games = GameCache.fetch(scope, 'games', @page)
    if games_count > PRIMARY_GAMES_COUNT && @page == 0
      @primary_games = GameCache.fetch(primary_scope, 'primary_games', 0, PRIMARY_GAMES_COUNT)
    end
    render :template => 'games/index'
  end

  def show
    begin
      @game = Game.find_by_slug_or_id(params[:id])
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

  def update
    update_with_bip(params[:game]) do |id|
      Game.find_by_slug_or_id(id)
    end
  end

  private
  def scope
    Game.where("id NOT IN (?)", primary_scope.limit(PRIMARY_GAMES_COUNT)).order(*GAMES_ORDER)
  end

  def primary_scope
    Game.order(*(['"primary" DESC'].append GAMES_ORDER))
  end

  def games_count
    GameCache.fetch_from('games_count') do
      Game.count
    end
  end
end
