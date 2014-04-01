class MainPageController < ApplicationController
  def not_found
  end

  def advertisers
  end

  def sitemap
    redirect_to '/sitemaps/sitemap.xml'
  end
end
