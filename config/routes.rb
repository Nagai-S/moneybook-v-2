Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    scope :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'

      resources :users do
        resources :events, only: :create
      end
    end
  end
  
  resources :users do
    resources :accounts, only: [:new, :create, :index, :destroy]
    resources :genres, only: [:index, :create, :new, :edit, :update, :destroy]
    resources :cards
    resources :events, only: [:index, :create, :new, :edit, :update, :destroy]
    resources :account_exchanges, only: [:index, :create, :new, :edit, :update, :destroy]
    get "account_month" => "accounts#month_index"
    get "explanation" => "homepages#explanation"
    get "search" => "events#search"
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'homepages#home'
end

