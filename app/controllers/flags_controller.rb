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
class FlagsController < ApplicationController
  before_filter :get_parent, only: :create

  def create
    @flag = Flag.new(params[:flag])
    @flag.flaggable = @flaggable
    @flag.save
    respond_to do |format|
      format.js
    end
  end

  def destroy
    flag = Flag.find(params[:id])
    @flaggable = flag.flaggable
    flag.destroy
    respond_to do |format|
      format.js
    end
  end
  private
  def get_parent
    if params[:flaggable_type] == "Link"
      @flaggable = Link.find(params[:flaggable_id]) 
    elsif params[:flaggable_type] == "Comment"
      @flaggable = Comment.find(params[:flaggable_id]) 
    end
  end
end