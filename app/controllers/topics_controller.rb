class TopicsController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update]

  def show
    @link = current_user.links.build  if current_user
    @topic = Topic.find_by_slug(params[:id])
    @links = @topic.topic_feed.paginate(page: params[:page], per_page: params[:per_page]||15)
    respond_to do |format|
      format.html
      format.js
    end
  end
  def edit
    @topic = Topic.find(params[:id])
  end
  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(params[:topic])
      flash.now[:success] = "Topic updated"
      redirect_to @topic
    else
      render 'edit'
    end
  end
end
