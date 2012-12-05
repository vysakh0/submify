class TopicDownvotesController < ApplicationController
  def create
    @vote = TopicDownvote.new(user_id: params[:topic_downvote][:user_id], topic_id: params[:topic], link_id: params[:link])
    @link = Link.find_by_id(params[:link])
    @topic = Topic.find_by_id(params[:topic])
    @vote.save
    respond_to do |format|
      format.js
    end
  end
  
  def destroy
    vote = TopicDownvote.find_by_id(params[:id])
    @link = vote.link
    @topic = vote.topic
    vote.destroy
    respond_to do |format|
      format.js
    end
  end
end
