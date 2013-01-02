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
    vote = Downvote.find(params[:id])
    @votable = vote.votable
    vote.destroy
    respond_to do |format|
      format.js
    end
  end
  private
  def get_parent
    if params[:votable_type] == "LinkUser"
      @votable = LinkUser.find(params[:votable_id]) 
    elsif params[:votable_type] == "Comment"
      @votable = Comment.find(params[:votable_id]) 
    end
  end
end
