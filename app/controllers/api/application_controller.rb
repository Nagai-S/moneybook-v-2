class Api::ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ApplicationHelper

  def currentUser
    uid = request.headers[:uid]
    @user = User.find_by(uid: uid)
  end

  def auth_user
    auth_access_key = request.headers['access-token']
    unless auth_access_key.to_s == ENV['AUTH_API_ACCESS_KEY'].to_s
      render json: { message: 'Unauthorized' }, status: 401
    end
  end
end
