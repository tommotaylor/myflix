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

  def create
    leader = User.find(params[:leader_id])
    Relationship.create(follower: current_user, leader: leader) if current_user.can_follow?(leader)
    flash[:success] = "You are now following #{leader.name}"
    redirect_to people_path
  end
end