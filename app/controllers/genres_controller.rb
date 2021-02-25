class GenresController < ApplicationController
  before_action :authenticate_user!
  before_action :select_genre, only: [:destroy, :edit, :update]
  
  def index
  end

  def new
    @genre=current_user.genres.build
  end

  def create
    @genre=current_user.genres.build(genres_params)
    if @genre.save
      redirect_to user_genres_path(current_user.id)
    else
      flash.now[:danger]="ジャンルの作成に失敗しました。"
      render 'new'
    end
  end
  
  def destroy
    if @genre.events.exists?
      index
      flash.now[:danger]="このジャンルを使用したイベントがあるので削除できません。"
      render "index"
    else
      @genre.destroy
      redirect_to user_genres_path(params[:user_id])
    end
  end
  
  def edit
  end

  def update
    if @genre.update(genres_params)
      redirect_to user_genres_path(params[:user_id])
    else
      flash.now[:danger]="ジャンルの編集に失敗しました。"
      render "edit"
    end
  end
  
  private
    def genres_params
      params.require(:genre).permit(:name, :iae)
    end

    def select_genre
      @genre=Genre.find_by(:user_id => params[:user_id], :id => params[:id])
    end
    
end
