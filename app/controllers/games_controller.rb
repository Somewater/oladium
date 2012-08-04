class GamesController < ApplicationController
  def index
    raise "fatal error: not implemented"
  end

  def show
    begin
      @game = Game.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    end

    if !@game && (params[:id] =~ /net-.+-id-.+/) == 0
      match = params[:id].match(/net-(.+)-id-(.+)/)
      net = match[1]
      net_id = match[2]
      a = Aggregator.mochi
      a.load
      @game = a.games.map{|g| g.to_game}.find{|g| g.net == net && g.net_id == net_id}
    end
  end
end