class AdminController < ApplicationController
  before_filter :check_admin
  def links
    @links = Link.joins(:flags).paginate(page: params[:page])
  end
  def comments
    @comments = Comment.joins(:flags).paginate(page: params[:page])
  end
  def topics
    @topics = Topic.where(verify: false).paginate(page: params[:page])
  end

  
  private
  def check_admin
    not_found  unless signed_in? and current_user.admin?
  end
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
