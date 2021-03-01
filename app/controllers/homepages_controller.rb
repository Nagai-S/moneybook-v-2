class HomepagesController < ApplicationController
  def home
  end

  def explanation
    @root= params[:root]
  end
end
