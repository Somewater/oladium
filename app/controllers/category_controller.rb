class CategoryController < ApplicationController
  def index
    raise "fatal error: not implemented"
  end

  def show
    begin
      @category = Category.find_by_id(params[:id]) || Category.find_by_name(params[:id])
      raise ActiveRecord::RecordNotFound unless @category
    rescue ActiveRecord::RecordNotFound
      flash.now.alert = I18n.t('categories.not_found')
      render 'main_page/not_found'
      return
    end

    @games = Game.where(["category_id = ? AND enabled = TRUE", @category.id]).order('priority DESC', 'created_at DESC')
    show_games_index()
  end

  def tags
    word = params[:tag].to_s.gsub(/\+([^\+]+)/,' \1').gsub('++', '+')
    @games = Game.where(["CONCAT(IFNULL(tags,'')) LIKE (?)", '%' + word.to_s + '%']).order('priority DESC', 'created_at DESC')
    show_games_index()
  end

  def show_games_index
    flash.now.notice = I18n.t('games.empty_set') if @games.size == 0

    render :template => 'games/index'
  end
end