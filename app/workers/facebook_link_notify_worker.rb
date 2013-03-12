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

class FacebookLinkNotifyWorker
  include Sidekiq::Worker
  #sidekiq_options queue: "high"
   sidekiq_options retry: false
  
  def perform(oauth_token, link, message)
    app = FbGraph::Application.new(FACEBOOK_CONFIG['app_id'])
    me = FbGraph::User.me(oauth_token)
    action = me.og_action!(
      app.og_action(:submit), # or simply "APP_NAMESPACE:ACTION" as String
      :link => link, 
      :message => message 
    )
  end
end
