class RelationshipsController < ApplicationController

before_action :require_user

  def index
    @relationships = current_user.following_relationships
  end

  def destroy
    @relationship = Relationship.find(params[:id])
    @relationship.destroy if @relationship.follower == current_user
    flash[:success] = "You are no longer following that user."
    redirect_to people_path
  end
end