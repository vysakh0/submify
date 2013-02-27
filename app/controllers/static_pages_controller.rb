#
# Submify - Dashboard of web and web activity
# Copyright (C) 2013 Vysakh Sreenivasan <support@submify.com>
#
# This file is part of Submify.
#
# Submify is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Submify is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Submify.  If not, see <http://www.gnu.org/licenses/>.
#
class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @link = current_user.links.build 
      @link_users = current_user.feed.paginate(page: params[:page], per_page: params[:per_page]|| 15)
      #@topics = Topic.joins(:topic_user_relationships).where("topic_user_relationships.user_id != ?", current_user.id).limit(5).uniq

      #Article.where.not(title: 'Rails 3') Rails 4 way :D
      @topics = current_user.suggest_topics
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
  def faq
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