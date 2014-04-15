class CategoryController < ApplicationController
  def index
    raise "fatal error: not implemented"
  end

  def show
    assign_page()
    begin
      @category = Category.find_by_id(params[:id]) || Category.find_by_name(params[:id])
      raise ActiveRecord::RecordNotFound unless @category
    rescue ActiveRecord::RecordNotFound
      flash.now.alert = I18n.t('categories.not_found')
      render 'main_page/not_found'
      return
    end

    assign_page()
    scope = Game.where(["category_id = ? AND enabled = TRUE", @category.id]).order('priority DESC', 'created_at DESC')
    @games = GameCache.fetch(scope, 'games:category:' + @category.name, @page)
    show_games_index()
  end

  def tags
    assign_page()
    @tag_word = params[:tag].to_s.gsub(/\+([^\+]+)/,' \1').gsub('++', '+')
    scope = Game.where(["CONCAT(COALESCE(tags,'')) ILIKE (?)", '%' + @tag_word.to_s + '%']).order('priority DESC', 'created_at DESC')
    @games = GameCache.fetch(scope, 'games:tag:' + @tag_word.to_s, @page)
    show_games_index()
  end

  def show_games_index
    flash.now.notice = I18n.t('games.empty_set') if @games.count == 0

    render :template => 'games/index'
  end
end