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
# Table name: flags
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  flaggable_id   :integer
#  flaggable_type :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Flag < ApplicationModel
  attr_accessible :user_id
  belongs_to :user
  belongs_to :flaggable, polymorphic: true
  validates :user_id, presence: true
end
