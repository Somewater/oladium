Oladium::Application.routes.draw do

  devise_for :developers, controllers: { registrations: "developers/registrations",
                                         sessions: "developers/sessions",
                                         passwords: "developers/passwords" }
  authenticate :developer do
    match 'developer/(:action)', :controller => 'developers/profiles', :as => 'developer'
  end

  match 'sitemap.xml' => 'main_page#sitemap'

  devise_for :users
  authenticate :user do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
    mount Ckeditor::Engine => '/ckeditor'
    mount RailsAdmin::Engine => '/rails_admin', :as => 'rails_admin'
    namespace 'admin' do
      match '(:action(/:task))' => 'admin', :defaults => {:action => 'index'}
    end
  end

  resources :games, :only => [:show, :index, :update]
  match 'minecraft(/:action)', :controller => 'minecraft', :as => 'minecraft', :defaults => {:action => 'index'}
  resources :category, :only => :show
  match 'tags/:tag' => 'category#tags', :as => 'tags'
  match 'ajax/:action', :controller => 'ajax', :as => 'ajax'

  match "search", :to => 'search#search_words'
  root :to => 'games#index'

  match "advertisers", :to => "main_page#advertisers", :as => "advertisers"

  match 'not_found' => 'main_page#not_found', :as => 'not_found'
  match '*paths' => 'main_page#not_found'
end
