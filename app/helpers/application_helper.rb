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
module ApplicationHelper
  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end
  def tab(value)
    @page_tab = value
  end
  def page_tab
    @page_tab
  end
  #this function allows you to input your account id when you call the function

  def google_analytics_js(id = nil)

    content_tag(:script, :type => 'text/javascript') do
      "var _gaq || [];
      _gaq.push(['_setAccount', '#{id}']);
      _gaq.push(['_trackPageview']);

      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = document.getElementByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })();"
    end if !id.blank? && Rails.env.production?
  end
end