class GenresController < ApplicationController
  before_action :authenticate_user!
  before_action :select_genre, only: [:destroy, :edit, :update]
  before_action :correct_user!, only: [:destroy, :edit, :update]
  before_action :set_previous_url, only: [:new, :edit]
  
  def index
  end

  def new
    @genre = current_user.genres.build(iae: params[:iae])
  end

  def create
    @genre = current_user.genres.build(genres_params)
    if @genre.save
      redirect_to_previou_url
    else
      flash.now[:danger] = "ジャンルの作成に失敗しました。"
      render 'new'
    end
  end
  
  def destroy
    @genre.before_destroy_action
    @genre.destroy
    redirect_to genres_path
  end
  
  def edit
  end

  def update
    if @genre.update(genres_params)
      redirect_to_previou_url
    else
      flash.now[:danger] = "ジャンルの編集に失敗しました。"
      render "edit"
    end
  end
  
  private
    def genres_params
      params.require(:genre).permit(:name, :iae)
    end

    def select_genre
      @genre = Genre.find_by(id: params[:id])
    end
    
    def correct_user!
      redirect_to root_path unless current_user == @genre.user
    end
end
