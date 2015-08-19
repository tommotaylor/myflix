class Admin::VideosController < ApplicationController

before_action :require_user
before_action :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
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
end