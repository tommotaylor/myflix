class VideosController < ApplicationController

  before_action :require_user

  def index
    @videos = Video.all
    @categories = Category.all
  end

  def show
  	@video = VideoDecorator.decorate(Video.find(params[:id]))
  end

  def search
    @results = Video.search_by_title(params[:search_term])
  end

  private

  def video_params
  	params.require(:video).permit(:title, :description, :small_cover_url, :large_cover_url)
  end


end