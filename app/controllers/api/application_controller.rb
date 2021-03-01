class Api::ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  def currentUser
    uid=request.headers[:uid]
    return User.find_by(uid: uid);
  end
  
end