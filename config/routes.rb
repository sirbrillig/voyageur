Voyageur::Application.routes.draw do
  get "home/index"

  devise_for :users

  root :to => 'home#index'

  get 'ping' => 'home#ping'
  get 'bust' => 'home#bust'

  resources :users do
    member do
      get 'audits'
    end
  end

  resources :locations do
    member do
      get 'audits'
    end
  end

  resources :trips do
    member do
      get 'clear'
    end
  end

  resources :triplocations do
  end

  match 'trips/:id/remove/:index' => 'trips#remove', :as => 'remove_trip'
  match 'trips/:id/up/:index' => 'trips#up', :as => 'up_trip'
  match 'trips/:id/down/:index' => 'trips#down', :as => 'down_trip'
  match 'trips/:id/move/:location_index/to/:index' => 'trips#move', :as => 'move_location'
  match 'trips/:id/add/:location_id' => 'trips#add', :as => 'add_location'
  match 'trips/:id/add/:location_id/at/:index' => 'trips#add', :as => 'insert_location'
end
