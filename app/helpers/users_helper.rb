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
module UsersHelper

  def render_users(users)
    if user.to_a.size > 0
      render(users)
    else
      content_tag(:div, "No users were found", class: 'msg')
    end
  end


  def gravatar_for(user)

    gravatar_url = "https://graph.facebook.com/#{user.uid}/picture"
    image_tag(gravatar_url, alt: user.name, class: "gravatar" )

  end

  def gravatar_for(user, options = { size: 50})
    size = options[:size]
    gravatar_url = "https://graph.facebook.com/#{user.uid}/picture?width=#{size}&height=#{size}"

    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

end