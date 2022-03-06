class ShortcutsController < ApplicationController
  before_action :authenticate_user!, except: :run
  before_action :correct_user!, only: %i[edit update destroy show]
  before_action :to_explanation, except: :run

  def index
    @shortcuts = current_user.shortcuts
  end
  
  def show
    @token = params[:token]
  end
  
  def new
    @shortcut = current_user.shortcuts.build
  end

  def create
    @shortcut = current_user.shortcuts.build(shortcut_params)
    if !current_user.valid_password? params[:shortcut][:password]
      flash.now[:danger] = "パスワードが違います。"
      render 'new'
      return
    end
    @token = @shortcut.create_token
    if @shortcut.save
      redirect_to shortcut_path(id: @shortcut.id, token: @token)
    else
      flash.now[:danger] = "ショートカットの作成に失敗しました。"
      render 'new'
    end
  end

  def update
    if !current_user.valid_password? params[:shortcut][:password]
      flash.now[:danger] = "パスワードが違います。"
      render 'show'
      return
    end
    @token = @shortcut.create_token
    if @shortcut.save
      redirect_to shortcut_path(id: @shortcut.id, token: @token)
    else
      flash.now[:danger] = "エラーが発生しました。"
      render 'show'
    end
  end
  
  def destroy
    if @shortcut.destroy
      redirect_to shortcuts_path
    else
      flash.now[:danger] = 'エラーが発生しました。ページをリロードしてください。'
      redirect_to shortcuts_path
    end
  end
  
  def run
    shortcut = Shortcut.find_by(id: params[:id])
    token = request.headers['access-token']
    if shortcut.valid_token?(token)
      shortcut.run_shortcut(params[:memo], params[:value])
      render json: {status: 'success', message: 'event is created'}
    else
      render json: {status: 'error', message: 'invalid access-token'}
    end
  end

  private
  def shortcut_params
    if params[:shortcut][:account_or_card] == '0'
      params[:shortcut][:card_id] = nil
    elsif params[:shortcut][:account_or_card] == '1'
      card = Card.find_by(id: params[:shortcut][:card_id])
      params[:shortcut][:account_id] = card.account_id
    end
    params.require(:shortcut).permit(:iae,:genre_id,:card_id,:account_id)
  end

  def correct_user!
    @shortcut = Shortcut.find_by(id: params[:id])
    redirect_to root_path unless current_user == @shortcut.user
  end
end
