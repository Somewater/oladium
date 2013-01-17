class GamesController < ApplicationController

  GAMES_PER_PAGE = 12

  def index
    assign_page()
    @games = Game.order('`usage` DESC', '(votes / votings) DESC', 'priority DESC', 'created_at DESC')
    if(@games.size > 15)
      primary_quantity = 3
      primary_quantity = 6 if @games.size > 30
      primary_quantity = 9 if @games.size > 50
      primary_quantity = 12 if @games.size > 100
      @primary_games = @games.slice!(0, primary_quantity)
    end
    render :template => 'games/index'
  end

  def show
    begin
      @game = Game.find_by_id(params[:id]) || Game.find_by_slug(params[:id]) || (raise ActiveRecord::RecordNotFound)
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