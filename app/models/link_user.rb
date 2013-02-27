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
# Table name: link_users
#
#  id         :integer          not null, primary key
#  link_id    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  topic_id   :integer
#  score      :integer
#

class LinkUser < ApplicationModel

  attr_accessible :link_id, :user_id, :topic_id

  belongs_to :link, class_name: "Link", touch: true
  belongs_to :user, class_name: "User", touch: true, counter_cache: true
  belongs_to :topic, class_name: "Topic", touch: true
  has_many :votes, as: :votable, dependent: :destroy
  has_many :downvotes,as: :votable, dependent: :destroy
  has_many :notifications, as: :parent

  default_scope order: 'link_users.created_at DESC'

  validates :link_id, presence: true
  after_create :calculate_score

  def calculate_score
    self.update_column(:score, (self.created_at.to_i/60))
  end

  def self.from_users_followed_by(user)
    followed_topic_ids = "SELECT topic_id FROM topic_user_relationships WHERE user_id = :user_id"
    followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    where("topic_id IN (#{followed_topic_ids}) OR  user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id).where('link_users.score> -10').uniq
  end
end
