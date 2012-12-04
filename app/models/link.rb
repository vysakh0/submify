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

class Link < ActiveRecord::Base
  
  attr_accessible :url_link,:url_heading
  has_many :link_users, foreign_key: "link_id", dependent: :destroy
  has_many :users, through: :link_users, source: :user

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :topics, through: :link_users, source: :topic

  has_many :votes, as: :votable, dependent: :destroy
  validates :url_link, uniqueness: true
  default_scope order: 'links.created_at DESC'

  def self.front_page

    top_ids = "SELECT votable_id FROM votes WHERE votable_type = 'Link' GROUP BY votable_id ORDER BY COUNT(*) DESC "

    where("id IN (#{top_ids})")
  end

  def following_comments user
    comments = self.comments
    comments.where("user_id IN (#{@followed_user_ids}) OR user_id = :user_id", user_id: user.id).limit(3).order('created_at desc')
  end
  def following_submits user
    users = self.users
    users.where("user_id IN (#{@followed_user_ids}) OR user_id = :user_id", user_id: user.id).limit(8)
  end

  def link_with_topic!(topic_name, user)
    topic = Topic.where(name: topic_name).first_or_create
    link_users.create!(topic_id: topic.id, user_id: user.id)
  end

  def self.from_users_followed_by(user)
    @followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    joins(:users).where("user_id IN (#{@followed_user_ids}) OR user_id = :user_id", user_id: user.id).uniq
  end
end
