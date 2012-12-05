class TopicsController < ApplicationController
  def show
    @topic = Topic.find_by_slug(params[:id])
    @links = @topic.links.paginate(page: params[:page])
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
