class MinecraftController < ApplicationController
  
  before_filter :set_category
  
  def index
    @text_page = TextPage.find_by_name('minecraft_index')
  end

  private
  def set_category
    @category = Category::MINECRAFT
  end
end
