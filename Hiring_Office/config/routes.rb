Rails.application.routes.draw do

  post "/rate" => "rates#create", as: "rate"
  post "/hook" => "paypals#update"

  resource :store_bookings, only: [:show, :update]

  resources :paypals
  resources :booking_histories, only: :index
  resources :order_histories, only: :index
  resources :static_pages, only: :index
  resource :confirm_payment_directlies
  resource :confirm_payment_bankings
  resources :reviews
  namespace :search do
    resources :spaces
    resources :users
    root to: "spaces#index"
  end

  root "static_pages#index"
  devise_for :admins, path: :admin, controllers: {sessions: "admin/sessions"}
  devise_for :users, controllers:
    {omniauth_callbacks: :omniauth_callbacks,  registrations: :registrations}
  resources :bookings
  resources :venues do
    resources :user_role_venues
    resources :spaces do
      resources :prices
    end
    resources :orders do
      resources :user_payment_directlies
      resources :user_payment_bankings
    end
    resource :venue_detail
    resources :venue_amenities
    resources :amenities do
      resources :service_charges
    end
    resource :venue_market
    resources :payment_methods
    resources :bankings
    resources :directlies
    resources :suggest_payment_methods
    resources :reports, only: [:create] 
  end
  resources :statistics, only: [:index, :create]

  resources :static_pages
  resources :notifications, only: [:index, :update]
  resources :reads, only: :update do
    post :'update', on: :collection
  end

  namespace :admin do
    root "statistics#index"
    resources :users
    resources :venues
    resources :statistics, only: [:index, :create]
    resources :activities, only: :index
    resources :supports
    resources :notifications
    resources :reads, only: :update do
      post :'update', on: :collection
    end
  end

  resources :supports
  resources :users

  mount ActionCable.server => '/cable'
end
