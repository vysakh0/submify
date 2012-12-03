class TopicsController < ApplicationController
  def show
    @topic = Topic.find_by_slug(params[:id])
    @links = @topic.links.paginate(page: params[:page])
  end
end
