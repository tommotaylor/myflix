class Admin::VideosController < ApplicationController

before_action :require_user
before_action :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      resize_images(@video)
      redirect_to @video
    else
      flash[:error] = "Please complete all fields"
      render :new
    end
  end

private

  def video_params
    params.require(:video).permit(:title, :description, :small_cover, :large_cover, :category_id)
  end

  def resize_images(video)
    small_cover = MiniMagick::Image.new(video.small_cover_url)
    small_cover.resize "166X236"
    large_cover = MiniMagick::Image.new(video.large_cover_url)
    large_cover.resize "665X375"
  end
end