class ApplicationController < ActionController::Base
  before_action :authenticate_user!, only: [
    :after_sign_in_path_for,
    :after_sign_up_path_for,
    :after_sign_out_path_for,
    :to_explanation
  ]

  def after_sign_in_path_for(resource)
    user_events_path(current_user) # ログイン後に遷移するpathを設定
  end

  def after_sign_up_path_for(resource)
    user_events_path(current_user) # アカウント作成後に遷移するpathを設定
  end

  def after_sign_out_path_for(resource)
    root_path # ログアウト後に遷移するpathを設定
  end

  def to_explanation
    unless current_user.accounts.exists? && current_user.genres.exists?(iae: false) && current_user.genres.exists?(iae: true)
      redirect_to user_explanation_path(current_user)
    end
  end
end
