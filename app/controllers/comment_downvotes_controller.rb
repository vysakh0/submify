class CommentDownvotesController < ApplicationController
  def create
    @vote = CommentDownvote.new(user_id: params[:comment_downvote][:user_id], comment_id: params[:comment])
    @comment = Link.find_by_id(params[:comment])
    @vote.save
    respond_to do |format|
      format.js
    end
  end
  
  def destroy
    vote = CommentDownvote.find_by_id(params[:id])
    @comment = vote.comment
    vote.destroy
    respond_to do |format|
      format.js
    end
  end
end
