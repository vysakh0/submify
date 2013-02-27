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
# == Schema Information
#
# Table name: votes
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  votable_id   :integer
#  votable_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Vote < ApplicationModel
  attr_accessible :votable_id, :user_id

  belongs_to :votable, polymorphic: true, touch: true, counter_cache: true
  belongs_to :user

  validates :user_id, presence: true
  after_create :score_and_notify
  has_many :notifications, as: :notifiable, dependent: :destroy

  def score_and_notify
    if votable.is_a? LinkUser
      link_user_score(votable)

    else 
      comment_score(votable)
    end
    notify = Notification.where(notifiable_type: "Vote" , user_id: votable.user.id, parent_id: votable_id, parent_type: votable_type).first_or_initialize
    notify.notifiable_id = id
    notify.save!
  end


  private 
  C = 45000

  def comment_score(comment)
    x = comment.votes_count  - comment.downvotes.count  #number of upvotes only
    if x <= 0
      score =  x
    else
      score = (C * (x + 1)) + (comment.created_at.to_i/60) 
    end
    comment.update_column(:score, score)

  end
  def link_user_score(link_user)
    score = link_user.created_at.to_i/60 #time is the default score 
    x = link_user.votes_count - link_user.downvotes.count 
    if x< 0 
      score =  x
    elsif x>=1
      score = (C * (x+1) ) +  score #-> this is reddit algorithm
    end
    link_user.update_column(:score, score)
  end
end
