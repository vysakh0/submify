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
class LinkScoreWorker
  include Sidekiq::Worker
  #sidekiq_options queue: "high"
  sidekiq_options retry: false
  C = 45000

  def perform(link_user_id, vote_id)
    link_user = LinkUser.find(link_user_id)
    score = link_user.created_at.to_i #time is the default score 
    x = link_user.votes.count - link_user.downvotes.count 
    if x< 0 
      score =  score + ( C* x)
    elsif x>=1
      score = (C * Math::log10(x+1) ) +  score #-> this is reddit algorithm
    end
    link_user.update_column(:score, score)
    Notification.create!(notifiable_id: vote_id, notifiable_type: "Vote", user_id: link_user.user.id)
  end
end