class KavalanController < ApplicationController
  before_filter :signed_in_user
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
    redirect_to(root_path) unless current_user.admin?
  end
end
