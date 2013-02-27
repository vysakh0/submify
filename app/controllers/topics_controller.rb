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
class TopicsController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update]
  before_filter :check_verification, only: [:edit, :update]

  def hovercard
    @topic = Topic.find(params[:id])
    render partial: 'hovercard'
  end

  def show
    @link = current_user.links.build  if current_user
    @topic = Topic.find(params[:id])
    @users = @topic.following_users.limit(5)
    @link_users = @topic.link_users.order("score DESC").paginate(page: params[:page], per_page: params[:per_page]||15)
    respond_to do |format|
      format.html
      format.js
    end
  end
  def followers
    @topic = Topic.find(params[:id])
    @users = @topic.following_users.paginate(page: params[:page])
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