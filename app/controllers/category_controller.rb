class CategoryController < ApplicationController
  def index
    raise "fatal error: not implemented"
  end

  def show
    begin
      @category = Category.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    end

    @games = Game.find(:all, :conditions => ["category_id = ?", @category.id])

    render :template => 'games/index'
  end
end