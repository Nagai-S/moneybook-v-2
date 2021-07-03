Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
  }

  namespace :api do
    scope :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'

      resources :events, only: [:create, :index]
      resources :account_exchanges, only: [:create, :index]

      get "daily_email" => "auth#daily_email"
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

  get '/sitemap', to: redirect(
    "https://s3-ap-northeast-1.amazonaws.com/#{ENV['S3_BUCKET_NAME']}/sitemap.xml.gz"
  )
  root 'homepages#home'
end

