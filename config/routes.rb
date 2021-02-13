Rails.application.routes.draw do
  devise_for :users, :controllers => {
   :registrations => 'users/registrations',
   :confirmations => 'users/confirmations',
   :sessions => 'users/sessions',
   :passwords => 'users/passwords'
  }

  resources :users do
    resources :accounts, only: [:new, :create, :index, :destroy]
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'homepages#home'
end

