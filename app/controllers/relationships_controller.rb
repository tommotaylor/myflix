class RelationshipsController < ApplicationController

before_action :require_user

  def index
    @relationships = current_user.following_relationships
  end

  def destroy
  end
end