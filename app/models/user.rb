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

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :link_users, foreign_key: "user_id", dependent: :destroy
  has_many :links, through: :link_users, source: :link

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy

  has_many :followed_users, through: :relationships, source: :followed

  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy

  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :comments, dependent: :destroy

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

  def feed
    Link.from_users_followed_by(self)
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

  def link_with_user!(given_link)
	link_users.create!(link_id: given_link.id) unless link_users.find_by_link_id(given_link.id)
  end
  
  def unlink_with_user!(given_link)
    link_users.find_by_link_id(given_link.id).destroy
  end
  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
