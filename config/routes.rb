# == Route Map
#
#                                Prefix Verb   URI Pattern                                                                              Controller#Action
#                           funds_index GET    /funds/index(.:format)                                                                   funds#index
#                          funds_search GET    /funds/search(.:format)                                                                  funds#search
#                      new_user_session GET    /users/sign_in(.:format)                                                                 devise/sessions#new
#                          user_session POST   /users/sign_in(.:format)                                                                 devise/sessions#create
#                  destroy_user_session DELETE /users/sign_out(.:format)                                                                devise/sessions#destroy
#                     new_user_password GET    /users/password/new(.:format)                                                            devise/passwords#new
#                    edit_user_password GET    /users/password/edit(.:format)                                                           devise/passwords#edit
#                         user_password PATCH  /users/password(.:format)                                                                devise/passwords#update
#                                       PUT    /users/password(.:format)                                                                devise/passwords#update
#                                       POST   /users/password(.:format)                                                                devise/passwords#create
#              cancel_user_registration GET    /users/cancel(.:format)                                                                  users/registrations#cancel
#                 new_user_registration GET    /users/sign_up(.:format)                                                                 users/registrations#new
#                edit_user_registration GET    /users/edit(.:format)                                                                    users/registrations#edit
#                     user_registration PATCH  /users(.:format)                                                                         users/registrations#update
#                                       PUT    /users(.:format)                                                                         users/registrations#update
#                                       DELETE /users(.:format)                                                                         users/registrations#destroy
#                                       POST   /users(.:format)                                                                         users/registrations#create
#                 new_user_confirmation GET    /users/confirmation/new(.:format)                                                        devise/confirmations#new
#                     user_confirmation GET    /users/confirmation(.:format)                                                            devise/confirmations#show
#                                       POST   /users/confirmation(.:format)                                                            devise/confirmations#create
#                  new_api_user_session GET    /api/v1/auth/sign_in(.:format)                                                           devise_token_auth/sessions#new
#                      api_user_session POST   /api/v1/auth/sign_in(.:format)                                                           devise_token_auth/sessions#create
#              destroy_api_user_session DELETE /api/v1/auth/sign_out(.:format)                                                          devise_token_auth/sessions#destroy
#                 new_api_user_password GET    /api/v1/auth/password/new(.:format)                                                      devise_token_auth/passwords#new
#                edit_api_user_password GET    /api/v1/auth/password/edit(.:format)                                                     devise_token_auth/passwords#edit
#                     api_user_password PATCH  /api/v1/auth/password(.:format)                                                          devise_token_auth/passwords#update
#                                       PUT    /api/v1/auth/password(.:format)                                                          devise_token_auth/passwords#update
#                                       POST   /api/v1/auth/password(.:format)                                                          devise_token_auth/passwords#create
#          cancel_api_user_registration GET    /api/v1/auth/cancel(.:format)                                                            devise_token_auth/registrations#cancel
#             new_api_user_registration GET    /api/v1/auth/sign_up(.:format)                                                           devise_token_auth/registrations#new
#            edit_api_user_registration GET    /api/v1/auth/edit(.:format)                                                              devise_token_auth/registrations#edit
#                 api_user_registration PATCH  /api/v1/auth(.:format)                                                                   devise_token_auth/registrations#update
#                                       PUT    /api/v1/auth(.:format)                                                                   devise_token_auth/registrations#update
#                                       DELETE /api/v1/auth(.:format)                                                                   devise_token_auth/registrations#destroy
#                                       POST   /api/v1/auth(.:format)                                                                   devise_token_auth/registrations#create
#             new_api_user_confirmation GET    /api/v1/auth/confirmation/new(.:format)                                                  devise_token_auth/confirmations#new
#                 api_user_confirmation GET    /api/v1/auth/confirmation(.:format)                                                      devise_token_auth/confirmations#show
#                                       POST   /api/v1/auth/confirmation(.:format)                                                      devise_token_auth/confirmations#create
#            api_v1_auth_validate_token GET    /api/v1/auth/validate_token(.:format)                                                    devise_token_auth/token_validations#validate_token
#                            api_events GET    /api/v1/events(.:format)                                                                 api/events#index
#                                       POST   /api/v1/events(.:format)                                                                 api/events#create
#                 api_account_exchanges GET    /api/v1/account_exchanges(.:format)                                                      api/account_exchanges#index
#                                       POST   /api/v1/account_exchanges(.:format)                                                      api/account_exchanges#create
#     api_fund_user_fund_user_histories GET    /api/v1/fund_users/:fund_user_id/fund_user_histories(.:format)                           api/fund_user_histories#index
#                        api_fund_users GET    /api/v1/fund_users(.:format)                                                             api/fund_users#index
#                       api_daily_email GET    /api/v1/daily_email(.:format)                                                            api/auth#daily_email
#                 api_update_fund_value GET    /api/v1/update_fund_value(.:format)                                                      api/auth#update_fund_value
#                      api_regist_funds POST   /api/v1/regist_funds(.:format)                                                           api/auth#regist_funds
#                 api_initial_regist_db POST   /api/v1/initial_regist_db(.:format)                                                      api/auth#initial_regist_db
#                              accounts GET    /accounts(.:format)                                                                      accounts#index
#                                       POST   /accounts(.:format)                                                                      accounts#create
#                           new_account GET    /accounts/new(.:format)                                                                  accounts#new
#                               account DELETE /accounts/:id(.:format)                                                                  accounts#destroy
#                                genres GET    /genres(.:format)                                                                        genres#index
#                                       POST   /genres(.:format)                                                                        genres#create
#                             new_genre GET    /genres/new(.:format)                                                                    genres#new
#                            edit_genre GET    /genres/:id/edit(.:format)                                                               genres#edit
#                                 genre PATCH  /genres/:id(.:format)                                                                    genres#update
#                                       PUT    /genres/:id(.:format)                                                                    genres#update
#                                       DELETE /genres/:id(.:format)                                                                    genres#destroy
#                                 cards GET    /cards(.:format)                                                                         cards#index
#                                       POST   /cards(.:format)                                                                         cards#create
#                              new_card GET    /cards/new(.:format)                                                                     cards#new
#                             edit_card GET    /cards/:id/edit(.:format)                                                                cards#edit
#                                  card GET    /cards/:id(.:format)                                                                     cards#show
#                                       PATCH  /cards/:id(.:format)                                                                     cards#update
#                                       PUT    /cards/:id(.:format)                                                                     cards#update
#                                       DELETE /cards/:id(.:format)                                                                     cards#destroy
#                                events GET    /events(.:format)                                                                        events#index
#                                       POST   /events(.:format)                                                                        events#create
#                             new_event GET    /events/new(.:format)                                                                    events#new
#                            edit_event GET    /events/:id/edit(.:format)                                                               events#edit
#                                 event PATCH  /events/:id(.:format)                                                                    events#update
#                                       PUT    /events/:id(.:format)                                                                    events#update
#                                       DELETE /events/:id(.:format)                                                                    events#destroy
#                     account_exchanges GET    /account_exchanges(.:format)                                                             account_exchanges#index
#                                       POST   /account_exchanges(.:format)                                                             account_exchanges#create
#                  new_account_exchange GET    /account_exchanges/new(.:format)                                                         account_exchanges#new
#                 edit_account_exchange GET    /account_exchanges/:id/edit(.:format)                                                    account_exchanges#edit
#                      account_exchange PATCH  /account_exchanges/:id(.:format)                                                         account_exchanges#update
#                                       PUT    /account_exchanges/:id(.:format)                                                         account_exchanges#update
#                                       DELETE /account_exchanges/:id(.:format)                                                         account_exchanges#destroy
#         fund_user_fund_user_histories GET    /fund_users/:fund_user_id/fund_user_histories(.:format)                                  fund_user_histories#index
#                                       POST   /fund_users/:fund_user_id/fund_user_histories(.:format)                                  fund_user_histories#create
#       new_fund_user_fund_user_history GET    /fund_users/:fund_user_id/fund_user_histories/new(.:format)                              fund_user_histories#new
#      edit_fund_user_fund_user_history GET    /fund_users/:fund_user_id/fund_user_histories/:id/edit(.:format)                         fund_user_histories#edit
#           fund_user_fund_user_history PATCH  /fund_users/:fund_user_id/fund_user_histories/:id(.:format)                              fund_user_histories#update
#                                       PUT    /fund_users/:fund_user_id/fund_user_histories/:id(.:format)                              fund_user_histories#update
#                                       DELETE /fund_users/:fund_user_id/fund_user_histories/:id(.:format)                              fund_user_histories#destroy
#                            fund_users GET    /fund_users(.:format)                                                                    fund_users#index
#                                       POST   /fund_users(.:format)                                                                    fund_users#create
#                         new_fund_user GET    /fund_users/new(.:format)                                                                fund_users#new
#                             fund_user PATCH  /fund_users/:id(.:format)                                                                fund_users#update
#                                       PUT    /fund_users/:id(.:format)                                                                fund_users#update
#                                       DELETE /fund_users/:id(.:format)                                                                fund_users#destroy
#                         account_month GET    /account_month(.:format)                                                                 accounts#month_index
#                           explanation GET    /explanation(.:format)                                                                   homepages#explanation
#                         events_search GET    /events/search(.:format)                                                                 events#search
#                               sitemap GET    /sitemap(.:format)                                                                       redirect(301, https://s3-ap-northeast-1.amazonaws.com/my-sitemap/sitemap.xml.gz)
#                                  root GET    /                                                                                        homepages#home
#         rails_postmark_inbound_emails POST   /rails/action_mailbox/postmark/inbound_emails(.:format)                                  action_mailbox/ingresses/postmark/inbound_emails#create
#            rails_relay_inbound_emails POST   /rails/action_mailbox/relay/inbound_emails(.:format)                                     action_mailbox/ingresses/relay/inbound_emails#create
#         rails_sendgrid_inbound_emails POST   /rails/action_mailbox/sendgrid/inbound_emails(.:format)                                  action_mailbox/ingresses/sendgrid/inbound_emails#create
#   rails_mandrill_inbound_health_check GET    /rails/action_mailbox/mandrill/inbound_emails(.:format)                                  action_mailbox/ingresses/mandrill/inbound_emails#health_check
#         rails_mandrill_inbound_emails POST   /rails/action_mailbox/mandrill/inbound_emails(.:format)                                  action_mailbox/ingresses/mandrill/inbound_emails#create
#          rails_mailgun_inbound_emails POST   /rails/action_mailbox/mailgun/inbound_emails/mime(.:format)                              action_mailbox/ingresses/mailgun/inbound_emails#create
#        rails_conductor_inbound_emails GET    /rails/conductor/action_mailbox/inbound_emails(.:format)                                 rails/conductor/action_mailbox/inbound_emails#index
#                                       POST   /rails/conductor/action_mailbox/inbound_emails(.:format)                                 rails/conductor/action_mailbox/inbound_emails#create
#     new_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/new(.:format)                             rails/conductor/action_mailbox/inbound_emails#new
#    edit_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id/edit(.:format)                        rails/conductor/action_mailbox/inbound_emails#edit
#         rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#show
#                                       PATCH  /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#update
#                                       PUT    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#update
#                                       DELETE /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#destroy
# rails_conductor_inbound_email_reroute POST   /rails/conductor/action_mailbox/:inbound_email_id/reroute(.:format)                      rails/conductor/action_mailbox/reroutes#create
#                    rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
#             rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#                    rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
#             update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#                  rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create

Rails.application.routes.draw do
  get 'funds/index'
  get 'funds/search'
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
  }

  namespace :api do
    scope :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'

      resources :events, only: [:create, :index]
      resources :account_exchanges, only: [:create, :index]
      resources :fund_users, only: [:index] do
        resources :fund_user_histories, only: [:index]
      end

      get "daily_email" => "auth#daily_email"
      get "update_fund_value" => "auth#update_fund_value"
      post "regist_funds" => "auth#regist_funds"
      post "initial_regist_db" => "auth#initial_regist_db"
    end
  end
  
  resources :accounts, only: [:new, :create, :index, :destroy]
  resources :genres, only: [:index, :create, :new, :edit, :update, :destroy]
  resources :cards
  resources :events, only: [:index, :create, :new, :edit, :update, :destroy]
  resources :account_exchanges, only: [:index, :create, :new, :edit, :update, :destroy]
  resources :fund_users, only: [:new, :create, :index, :destroy, :update] do
    resources :fund_user_histories, only: [:new, :create, :index, :destroy, :edit, :update]
  end
  get "account_month" => "accounts#month_index"
  get "explanation" => "homepages#explanation"
  get "events/search" => "events#search"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/sitemap', to: redirect(
    "https://s3-ap-northeast-1.amazonaws.com/#{ENV['S3_BUCKET_NAME']}/sitemap.xml.gz"
  )
  root 'homepages#home'
end

