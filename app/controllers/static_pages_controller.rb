class StaticPagesController < ApplicationController

  caches_action :home
  def home
    if signed_in?
      @link = current_user.links.build 
      @feed_items = current_user.feed.paginate(page: params[:page])
      expires_in 5.minutes
      respond_to do |format|
        format.js
        format.html
      end
    else
      @links = Link.front_page.paginate(page: params[:page])
      expires_in 5.minutes
    end
  end
  def autocomplete
    result = User.search(params['term']) +  Topic.search(params['term'])
render :json => result
  end
  def autocomplete_topic_name
    render :json => Topic.search(params['term'])
  end
  
  def front_page
      @links = Link.front_page.paginate(page: params[:page])
  end

  def contact
  end
end
