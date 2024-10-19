class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_previous_url, only: %i[edit]

  def edit; end

  def update
    if current_user.update(user_params)
      redirect_to_previou_url
    else
      flash.now[:danger] = 'エラーが起きました'
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:timezone)
  end
end
