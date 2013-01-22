class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @link = current_user.links.build 
      @link_users = current_user.feed.paginate(page: params[:page], per_page: params[:per_page]|| 15)
      respond_to do |format|
        format.js
        format.html
      end
    else
     front_page 
    end
  end
  def autocomplete
    result = User.search(params['term']) +  Topic.search(params['term'])
render :json => result
  end
  def autocomplete_topic_name
    render :json => Topic.search(params['term'])
  end
  
def privacy
end
  def front_page
      @link_users = LinkUser.order("score DESC").limit(100).paginate(page: params[:page])
      unless signed_in?
        render 'home'
      end
  end

  def contact
  end
end
