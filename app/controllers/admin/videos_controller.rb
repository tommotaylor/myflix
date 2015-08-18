class Admin::VideosController < ApplicationController

before_action :require_user
before_action :require_admin

  def new
  end

  def create
  end

end