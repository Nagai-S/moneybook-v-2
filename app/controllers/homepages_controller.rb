class HomepagesController < ApplicationController
  before_action :authenticate_user!, only: :explanation
  def home
    render :layout => 'home'
  end

  def explanation
  end
end
