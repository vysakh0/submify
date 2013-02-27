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
module FlashLinkHelper

  def flash_display
    response = ""
    flash.each do |key, value| 
      response = response + content_tag(:div, value, class: "alert alert-#{key}")

    end
    flash.discard
    response
  end

  def notify_count
    unless current_user.nil?
      current_user.notifications.where("updated_at > ?", current_user.notify).count  
    else
      0
    end

  end

end