class VideosController < ApplicationController

  def index
  	@videos = Video.all
  end

  def show
  	@video = Video.first
  end

private

  def video_params
  	params.require(:video).permit(:title, :description, :small_cover_url, :large_cover_url)
  end


end