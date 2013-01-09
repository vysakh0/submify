# == Schema Information
#
# Table name: links
#
#  id                  :integer          not null, primary key
#  url_link            :string(255)
#  url_heading         :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#

require 'uri'
require 'open-uri'

class Link < ActiveRecord::Base

  include Tire::Model::Search
  include Tire::Model::Callbacks

  attr_accessible :url_link,:url_heading
  has_many :flags, as: :flaggable
  has_many :link_users, foreign_key: "link_id", dependent: :destroy
  has_many :users, through: :link_users, source: :user

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :topics, through: :link_users, source: :topic

  validates :url_link, uniqueness: true

  def link_with_topic!(topic_name, user, topic_page)
    topic_slug = topic_name.to_s.parameterize
    if topic_page
      topic = topic_page
    elsif topic = Topic.find_by_slug(topic_slug)
    else
      topic = Topic.create!(name: topic_name)
    end
     LinkUser.create!(topic_id: topic.id, user_id: user.id, link_id: self.id)
  end

  def self.search(params)

    tire.search(load: true) do
      query { string params[:q], default_operator: "OR" } if params[:q].present?
      #    filter :range, published_at: {lte: Time.zone.now}
    end
    # raise to_curl
  end


  def to_param
    "#{id} #{url_heading}".parameterize
  end
end
