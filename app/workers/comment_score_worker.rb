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
class CommentScoreWorker
  include Sidekiq::Worker
  #sidekiq_options queue: "high"
  sidekiq_options retry: false
  C = 45000

  def perform(comment_id)
    comment = Comment.find_by_id(comment_id)
    x = comment.votes.count  - comment.downvotes.count  #number of upvotes only
    if x <= 0
      score =  x
    else
      score = (C * Math::log10(x + 1)) + comment.created_at.to_i 
    end
    comment.update_column(:score, score)

    Notification.create!(notifiable_id: notifable_id, notifiable_type: notifiable_type , user_id: link_user.user.id)
  end
end