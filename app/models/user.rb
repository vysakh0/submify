# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#
require 'open-uri'
require 'uri'

class User < ActiveRecord::Base

  extend FriendlyId
  friendly_id :username, use: :slugged
  attr_accessible :avatar
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  has_many :flags

  has_many :topic_user_relationships, foreign_key: "user_id", dependent: :destroy

  has_many :followed_topics, through: :topic_user_relationships, source: :topic

  has_many :comment_downvotes, dependent: :destroy
  has_many :link_users, foreign_key: "user_id", dependent: :destroy
  has_many :links, through: :link_users, source: :link

  has_many :comments, dependent: :destroy

  has_many :votes, dependent: :destroy
  has_many :topic_downvotes, dependent: :destroy

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy

  has_many :followed_users, through: :relationships, source: :followed

  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy

  has_many :followers, through: :reverse_relationships, source: :follower

  #  has_secure_password

  before_save { |user| user.email = email.downcase }

  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
    format: { with: VALID_EMAIL_REGEX }, 
    uniqueness: { case_sensitive: false} 
  #  validates :password, presence: true, length: { minimum: 6 }
  #  validates :password_confirmation, presence: true
  after_save :make_following
  after_save :load_into_soulmate

  def load_into_soulmate
    loader = Soulmate::Loader.new("user")
    loader.add("term" => name, "id" => id,"data" => { "url" => Rails.application.routes.url_helpers.user_path(self), "imgsrc" => avatar.url } )
  end
  def self.search(term)
    matches = Soulmate::Matcher.new('user').matches_for_term(term)
    matches.collect {|match| {"id" => match["id"], "label" => match["term"], "value" => match["term"], "url"  => match["data"]["url"], "imgsrc" => match["data"]["imgsrc"] } }
  end 

  def self.from_omniauth(auth)
    where(auth.slice(:uid)).first_or_initialize.tap do |user|
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.username = auth.extra.raw_info.username
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.avatar = URI.parse("https://graph.facebook.com/#{auth.uid}/picture")
      user.save!
    end
  end

  def make_following
    new_user = FbGraph::User.fetch(uid, access_token: oauth_token)
    new_user.friends.each do |friend|
    if  existing_user = User.find_by_uid(friend.identifier)
      follow!(existing_user)
      existing_user.follow!(self)
    end
    end
  end
  def picture_from_url(url)
    self.avatar = URI.parse(url) 
  end

  def feed
    Link.from_users_followed_by(self)
  end

  def commented
    Comment.where("user_id = #{self.id} AND commentable_type = 'Link' ")
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def vote?(votable)
    votes.find_by_votable_id(votable.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def topic_following?(topic)
    topic_user_relationships.find_by_topic_id(topic.id)
  end

  def topic_follow!(topic)
    topic_user_relationships.create!(topic_id: topic.id)
  end

  def topic_unfollow!(topic)
    topic_user_relationships.find_by_topic_id(topic.id).destroy
  end

  def link_with_user!(given_link)
    link_users.create!(link_id: given_link.id)
  end

  def unlink_with_user!(given_link)
    link_users.find_by_link_id(given_link.id).destroy
  end

  def create_remember_token
    SecureRandom.urlsafe_base64
  end
end
