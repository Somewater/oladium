Oladium::Application.routes.draw do

  devise_for :developers

  match 'sitemap.xml' => 'sitemaps#sitemap'
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users
  mount RailsAdmin::Engine => '/rails_admin', :as => 'rails_admin'

  authenticate :user do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace 'admin' do
    match '(:action(/:task))' => 'admin', :defaults => {:action => 'index'}
  end

  resources :games, :only => [:show, :index]
  match 'minecraft(/:action)', :controller => 'minecraft', :as => 'minecraft', :defaults => {:action => 'index'}
  resources :category, :only => :show
  match 'tags/:tag' => 'category#tags', :as => 'tags'
  match 'ajax/:action', :controller => 'ajax', :as => 'ajax'

  match "search", :to => 'search#search_words'
  root :to => 'games#index'

  match 'not_found' => 'main_page#not_found', :as => 'not_found'
  match '*paths' => 'main_page#not_found'
end
