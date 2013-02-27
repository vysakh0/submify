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
# Table name: relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Relationship < ApplicationModel
  attr_accessible :followed_id
  belongs_to :follower, class_name: "User", touch: true
  has_many :notifications, as: :parent, dependent: :destroy
  belongs_to :followed, class_name: "User", touch: true, counter_cache: true

  validates :follower_id, presence: true
  validates :followed_id, presence: true
  after_save :notify


  def notify
      Notification.create!(notifiable_id: follower_id , notifiable_type: "User", user_id: followed_id, parent_id: id, parent_type: "Relationship")
  end
end
