class TopicUserRelationshipsController < ApplicationController
  before_filter :signed_in_user

  def create
    @topic = Topic.find(params[:topic_user_relationship][:topic_id])
    current_user.topic_follow!(@topic)
    respond_to do |format|
      format.html { redirect_to @topic }
      format.js
    end
  end

  def destroy
    @topic = TopicUserRelationship.find(params[:id]).topic
    current_user.topic_unfollow!(@topic)
    respond_to do |format|
      format.html { redirect_to @topic }
      format.js
    end
  end
end
