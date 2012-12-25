class DownvotesController < ApplicationController
  before_filter :get_parent, only: :create
  def create
    @vote = Downvote.new(params[:downvote])
    @vote.votable = @votable
    @vote.save
    respond_to do |format|
      format.js
    end
  end
  
  def destroy
    vote = Downvote.find_by_id(params[:id])
    @votable = vote.votable
    vote.destroy
    respond_to do |format|
      format.js
    end
  end
  private
  def get_parent
    @votable = LinkUser.find_by_id(params[:votable_id]) if params[:votable_type] == "LinkUser"
    @votable = Comment.find_by_id(params[:votable_id]) if params[:votable_type] == "Comment"
  end
end
