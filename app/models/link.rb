# == Schema Information
#
# Table name: links
#
#  id          :integer          not null, primary key
#  url_link    :string(255)
#  url_heading :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string(255)
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

  has_many :votes, as: :votable, dependent: :destroy
  validates :url_link, uniqueness: true
  attr_accessible :avatar
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  def link_comments
    Comment.show_link_comments(self.id)
  end
  #def self.front_page
    #order('created_at DESC').order('score')
  #end

  def following_comments user
    followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    self.comments.where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id).limit(3).order('created_at desc')
  end

  def link_with_topic!(topic_name, user, topic_page)
    topic_slug = topic_name.to_s.parameterize
    if topic_page
      topic = topic_page
    elsif topic = Topic.find_by_slug(topic_slug)
    else
      topic = Topic.create!(name: topic_name)
      topic.save
    end
    link_users.create!(topic_id: topic.id, user_id: user.id)
  end

  def self.feed_topic (topic_id)
    joins(:topic_downvotes).group("topic_id, links.id").where("topic_id = #{topic_id}").order("count(*)").order('links.created_at DESC')
  end

  def picture_from_url(url)
    self.avatar = URI.parse(url) 
  end


  def self.search(params)

    tire.search(load: true) do
      query { string params[:q], default_operator: "AND" } if params[:q].present?
      #    filter :range, published_at: {lte: Time.zone.now}
    end
    # raise to_curl
  end

  # self.include_root_in_json = false (necessary before Rails 3.1)
  def to_indexed_json
    to_json(methods: [:topics_name])
  end

  def to_param
    "#{id} #{url_heading}".parameterize
  end

  def author_name
    topics.collect {|topic|  topic.name  }
  end

end
