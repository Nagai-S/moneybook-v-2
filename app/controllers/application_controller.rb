class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  protect_from_forgery unless: -> { request.format.json? } 
  before_action :set_host
  before_action :authenticate_user!, only: [
    :after_sign_in_path_for,
    :after_sign_out_path_for,
    :to_explanation
  ]

  def after_sign_in_path_for(resource)
    user_events_path(current_user) # ログイン後に遷移するpathを設定
  end

  def after_sign_out_path_for(resource)
    root_path # ログアウト後に遷移するpathを設定
  end

  def to_explanation
    unless current_user.accounts.exists? && current_user.genres.exists?(iae: false) && current_user.genres.exists?(iae: true)
      redirect_to user_explanation_path(current_user)
    end
  end

  private
    def set_host
      Rails.application.routes.default_url_options[:host] = request.host_with_port
    end
end
