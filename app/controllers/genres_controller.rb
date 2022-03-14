class GenresController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user!, only: %i[destroy show]

  def index; end

  def new
    @genre = current_user.genres.build(iae: params[:iae])
    set_previous_url
  end

  def create
    @genre = current_user.genres.build(genres_params)
    if @genre.save
      redirect_to_previou_url
    else
      flash.now[:danger] = 'ジャンルの作成に失敗しました。'
      render 'new'
    end
  end

  def show
    @events = @genre.events.page(params[:event_page]).per(50)
  end

  def destroy
    @genre.destroy
    redirect_to_referer
  end

  def update
    @genre = current_user.genres.find(params[:id])
    if @genre.update(name: params[:genre][:name])
      render json: { status: 'success' }
    else
      render json: { status: 'error' }
    end
  end

  private

  def genres_params
    params.require(:genre).permit(:name, :iae)
  end

  def correct_user!
    @genre = Genre.find_by(id: params[:id])
    redirect_to root_path unless current_user == @genre.user
  end
end
