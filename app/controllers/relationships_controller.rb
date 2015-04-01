class RelationshipsController < ApplicationController
  
  before_filter :require_logged_in

  def index
    @relationships = current_user.following_relationships
  end

  def destroy
    relationship = Relationship.find(params[:id])
    relationship.delete if relationship.follower == current_user
    redirect_to people_path
  end

end