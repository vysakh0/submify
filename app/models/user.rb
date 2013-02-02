# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  email               :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  password_digest     :string(255)
#  remember_token      :string(255)
#  admin               :boolean          default(FALSE)
#  slug                :string(255)
#  uid                 :string(255)
#  oauth_token         :string(255)
#  oauth_expires_at    :datetime
#  username            :string(255)
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  description         :text
#

require 'open-uri'
require 'uri'

class User < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: :slugged
  attr_accessible :avatar, :description, :name, :notifications_count, :email, :uid, :username, :oauth_token, :oauth_expires_at, :password, :password_confirmation

  has_attached_file :avatar, styles: { medium: "200x200>", thumb: "100x100"}, default_style: :thumb
  has_many :flags

  has_many :topic_user_relationships, foreign_key: "user_id", dependent: :destroy

  has_many :followed_topics, through: :topic_user_relationships, source: :topic

  has_many :downvotes
  has_many :link_users, foreign_key: "user_id", dependent: :destroy
  has_many :links, through: :link_users, source: :link

  has_many :comments, dependent: :destroy

  has_many :notifications
  has_many :votes

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy

  has_many :followed_users, through: :relationships, source: :followed

  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy

  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :notifiable, through: :notifications

  has_secure_password

  before_save { |user| user.email = email.downcase }

  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
    format: { with: VALID_EMAIL_REGEX }, 
    uniqueness: { case_sensitive: false} 
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  after_save :make_following
  after_save :load_into_soulmate
  before_destroy :remove_from_soulmate
  before_create :make_pic

  #def user_name
  #Rails.cache.fetch([:user, id, :name]) do
  #name
  #end
  #end

  #def flush_name_cache
  #Rails.cache.delete([:user, id, :name]) if name_changed?
  #end

  def remove_from_soulmate
    loader = Soulmate::Loader.new("user")
    loader.remove("term" => name, "id" => id,"data" => { "url" => "/users/#{slug}", "imgsrc" => avatar.url(:thumb) } )
  end
  def load_into_soulmate
    loader = Soulmate::Loader.new("user")
    loader.add("term" => name, "id" => id,"data" => { "url" => "/users/#{slug}", "imgsrc" => avatar.url(:thumb) } )
  end
  def self.search(term)
    matches = Soulmate::Matcher.new('user').matches_for_term(term)
    matches.collect {|match| {"id" => match["id"], "label" => match["term"], "value" => match["term"], "url"  => match["data"]["url"], "imgsrc" => match["data"]["imgsrc"], "category" => "user"} }
  end 

  def self.from_omniauth(auth)
    where(auth.slice(:uid)).first_or_initialize.tap do |user|
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.username = auth.extra.raw_info.username
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      #user.avatar = URI.parse("https://graph.facebook.com/#{auth.uid}/picture")
    end
  end
  def make_pic
  if self.uid
    self.avatar = URI.parse("https://graph.facebook.com/#{self.uid}/picture") 
  end
  end

  def send_password_reset
    #self.password_reset_sent_at = Time.zone.now
    #save!
    self.update_column(:password_reset_token,SecureRandom.urlsafe_base64)
    self.update_column(:password_reset_sent_at, Time.zone.now)
    UserMailer.password_reset(self).deliver

  end
  def send_confirmation
    #self.password_reset_sent_at = Time.zone.now
    #save!
    self.update_column(:password_reset_token,SecureRandom.urlsafe_base64)
    self.update_column(:password_reset_sent_at, Time.zone.now)
    UserMailer.confirmation(self).deliver
  end


  def make_following
    FacebookFriendWorker.perform_async(uid, oauth_token)
  end

  def picture_from_url(url)
    self.avatar = URI.parse(url) 
  end

  def feed
    LinkUser.from_users_followed_by(self)
  end

  def commented
    Comment.where("user_id = #{self.id} AND commentable_type = 'Link' ").order("created_at DESC")
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
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
  def suggest_topics
    followed_topics = "SELECT topic_id FROM topic_user_relationships WHERE (user_id = #{self.id})"
    Topic.where("id NOT IN (#{followed_topics})").limit(5)

  end

  def from_user_suggest(current)
    followed_topics = "SELECT topic_id FROM topic_user_relationships WHERE (user_id = #{current})"
    self.followed_topics.where("topics.id NOT IN (#{followed_topics})").limit(5)
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
