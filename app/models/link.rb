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
  self.per_page = 10


  has_many :votes, as: :votable, dependent: :destroy
  has_many :topic_downvotes, dependent: :destroy
  validates :url_link, uniqueness: true
  default_scope order: 'links.created_at DESC'
  attr_accessible :avatar
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }


  def link_comments
    Comment.show_link_comments(self.id)
  end
  def self.front_page

    top_ids = "SELECT votable_id FROM votes WHERE votable_type = 'Link' GROUP BY votable_id ORDER BY COUNT(*) DESC "

    where("id IN (#{top_ids})")
  end

  def following_comments user
    followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    comments = self.comments
    comments.where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id).limit(3).order('created_at desc')
  end
  def following_submits user
    users = self.users
    users.where("user_id IN (#{@followed_user_ids}) OR user_id = :user_id", user_id: user.id).limit(8)
  end

  def link_with_topic!(topic_name, user)
    topic = Topic.where(name: topic_name).first_or_create
    link_users.create!(topic_id: topic.id, user_id: user.id)
  end

  def self.feed_topic (topic_id)
    unscoped.joins(:topic_downvotes).group("topic_id, links.id").where("topic_id = #{topic_id}").order("count(*)").order('links.created_at DESC')
  end

  def picture_from_url(url)
    self.avatar = URI.parse(url) 
  end
  def self.from_users_followed_by(user)
    followed_topic_ids = "SELECT topic_id FROM topic_user_relationships WHERE user_id = :user_id"
    joins(:link_users).where("topic_id IN (#{followed_topic_ids}) OR user_id = :user_id", user_id: user.id).uniq
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

  def author_name
    topics.collect {|topic|  topic.name  }
  end

end
