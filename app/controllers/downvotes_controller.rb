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
class DownvotesController < ApplicationController
  before_filter :get_parent, only: :create
  def create
    @vote = Downvote.new(params[:downvote])
    @vote.votable = @votable
    @vote.save
    respond_to do |format|
      format.js
    end
  end

  def destroy
    vote = Downvote.find(params[:id])
    @votable = vote.votable
    vote.destroy
    respond_to do |format|
      format.js
    end
  end
  private
  def get_parent
    if params[:votable_type] == "LinkUser"
      @votable = LinkUser.find(params[:votable_id]) 
    elsif params[:votable_type] == "Comment"
      @votable = Comment.find(params[:votable_id]) 
    end
  end
end