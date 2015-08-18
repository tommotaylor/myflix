class Admin::VideosController < ApplicationController

before_action :require_user
before_action :require_admin

  def new
    @video = Video.new
  end

  def create
  end

end