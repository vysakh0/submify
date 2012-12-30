class TopicsController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update]
  before_filter :check_verification, only: [:edit, :update]

  def hovercard
    @topic = Topic.find_by_id(params[:id])
    render partial: 'hovercard'
  end

  def show
    @link = current_user.links.build  if current_user
    @topic = Topic.find_by_slug(params[:id])
    @link_users = @topic.link_users.order("score DESC").paginate(page: params[:page], per_page: params[:per_page]||15)
    respond_to do |format|
      format.html
      format.js
    end
  end
  def edit
    @topic = Topic.find(params[:id])
  end
  def update
    if params[:verify]=="true"
      @topic.toggle!(:verify)
    end
    if @topic.update_attributes(params[:topic])
      flash.now[:success] = "Topic updated"
      redirect_to @topic
    else
      render 'edit'
    end
  end
  def index
    @topics = Topic.limit(100).paginate(page: params[:page])
  end

  private

  def check_verification
    @topic = Topic.find(params[:id])
    if @topic.verify? and !(current_user.admin?)
      flash[:notice] = "The topic is closed for editing by admin"
      redirect_to @topic
    end
  end
end
