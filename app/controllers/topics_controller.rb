class TopicsController < ApplicationController
  def show
    @link = current_user.links.build  if current_user
    @topic = Topic.find_by_slug(params[:id])
    @links = @topic.topic_feed.paginate(page: params[:page], per_page: params[:per_page]||15)
    params[:page] = 2
    respond_to do |format|
      format.html
      format.js
    end
  end
  def edit
    @topic = Topic.find(params[:id])
  end
  def unsubmit
    unsubmit = LinkUser.find(params[:unsubmit])
    unsubmit.destroy
    topic = Topic.find(params[:topic])
    redirect_to topic
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
