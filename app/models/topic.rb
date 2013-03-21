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
# Table name: topics
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :text
#  slug                :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  verify              :boolean          default(FALSE)
#

class Topic < ApplicationModel
  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_accessible :description, :name, :avatar
  has_attached_file :avatar, styles: { medium: "200x200>", thumb: "100x100"}, default_style: :thumb, default_url:'/images/avatar/missing_topic_thumb.png'
  validates_attachment_content_type :avatar, :content_type => /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/, :message => 'file type is not allowed (only jpeg/png/gif images)'

  has_many :link_users, foreign_key: "topic_id", dependent: :destroy
  has_many :links, through: :link_users, source: :link

  has_many :topic_user_relationships, foreign_key: "topic_id", dependent: :destroy

  has_many :following_users, through: :topic_user_relationships, source: :user
  
  after_save :load_soulmate

  before_destroy :remove_soulmate

  #def topic_name
    #Rails.cache.fetch([:topic, id, :name]) do
      #name
    #end
  #end

  #def flush_name_cache
    #Rails.cache.delete([:topic, id, :name]) if name_changed?
  #end


  def remove_soulmate
    do_soulmate_by_operation self.class.name.downcase, :remove
    # remove_from_soulmate self.class.name.downcase
  end
  
  def load_soulmate
    do_soulmate_by_operation self.class.name.downcase, :add
    # load_into_soulmate self.class.name.downcase
  end

  def self.search(term)
    match_from_soulmate(term,self.name.downcase) 
  end

end
