class StaticPagesController < ApplicationController
  def home
    if signed_in?
    @link = current_user.links.build if signed_in?
    @feed_items = current_user.feed.paginate(page: params[:page])
    respond_to do |format|
      format.js
      format.html
    end
    end
  end


  def contact
  end
end
