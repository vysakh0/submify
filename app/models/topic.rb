class Topic < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_accessible :description, :name

  has_many :links, through: :link_users, source: :link


end
