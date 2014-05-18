# encoding: utf-8

class  Admin::GamesController <  Admin::AdminBaseController
  def index
    if request.xhr?

    end
  end

  def edit
    @game = Game.find_by_slug_or_id(params[:id])
  end

  def update
    @game = Game.find_by_slug_or_id(params[:id])
  end
end