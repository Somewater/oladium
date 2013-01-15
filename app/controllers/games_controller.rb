class GamesController < ApplicationController

  GAMES_PER_PAGE = 12

  def index
    @page = [params[:page].to_i - 1, 0].max if params[:page]
    @games = Game.order('priority DESC', 'created_at DESC')
    @primary_games = @games.take(4)
    render :template => 'games/index'
  end

  def show
    begin
      @game = Game.find_by_id(params[:id]) || Game.find_by_slug(params[:id])
    rescue ActiveRecord::RecordNotFound
      if !@game && (params[:id] =~ /net-.+-id-.+/) == 0
        match = params[:id].match(/net-(.+)-id-(.+)/)
        net = match[1]
        net_id = match[2]
        a = Aggregator.send(net.to_sym)
        a.load
        @game = a.games.map{|g| g.to_game}.find{|g| g.net == net && g.net_id == net_id}
      end
    end

    unless @game
      flash.now.alert = I18n.t('games.not_found')
      render 'main_page/not_found'
      return
    end

    @game.usage += 1
    @game.save unless @game.new_record?
  end
end