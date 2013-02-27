class Notification < ApplicationModel
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
  attr_accessible :notifiable_id, :notifiable_type, :parent_id, :parent_type

  attr_accessible :user_id
  belongs_to :user
  belongs_to :notifiable, polymorphic: true
  belongs_to :parent, polymorphic: true
  validates :user_id, presence: true
  after_save :inc_counter
  before_destroy :dec_counter

  def inc_counter
    user.update_column(:notifications_count, user.notifications_count + 1)
  end 
  def dec_counter
    count = (user.notifications_count - 1) 
    count = 0 if count < 0
    user.update_column(:notifications_count, count)
  end 
end
