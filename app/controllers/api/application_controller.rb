class Api::ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  protect_from_forgery with: :null_session

  def currentUser
    uid=request.headers[:uid]
    return User.find_by(uid: uid);
  end
  
end