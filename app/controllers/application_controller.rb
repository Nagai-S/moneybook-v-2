class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :exception
  protect_from_forgery unless: -> { request.format.json? }
  before_action :set_host
  before_action :set_time_zone
  before_action :authenticate_user!,
                only: %i[
                  after_sign_in_path_for
                  after_sign_out_path_for
                  to_explanation
                ]

  def after_sign_in_path_for(resource)
    events_path # ログイン後に遷移するpathを設定
  end

  def after_sign_out_path_for(resource)
    root_path # ログアウト後に遷移するpathを設定
  end

  def to_explanation
    unless current_user.genres.exists?
      current_user.genres.create(
        [
          { iae: false, name: '食費' },
          { iae: false, name: '日用品' },
          { iae: false, name: '交通費' },
          { iae: false, name: '交際費' },
          { iae: true, name: '給料' },
          { iae: true, name: 'ボーナス' },
          { iae: true, name: 'お小遣い' }
        ]
      )
    end
    redirect_to explanation_path unless current_user.accounts.exists?
  end

  def set_previous_url
    if !Rails.env.test? && request.referer
      session[:previous_url] = request.referer
    else
      session[:previous_url] = root_path
    end
  end

  def redirect_to_previou_url
    unless Rails.env.test?
      redirect_to session[:previous_url]
      session[:previous_url].clear
    else
      redirect_to root_path
    end
  end

  def redirect_to_referer
    if !Rails.env.test? && request.referer
      redirect_to request.referer
    else
      redirect_to root_path
    end
  end

  private

  def set_host
    Rails.application.routes.default_url_options[:host] = request.host_with_port
  end

  def set_time_zone
    if user_signed_in?
      Time.zone = current_user.timezone
    end
  end
end
