class Link < ActiveRecord::Base
  attr_accessible :url_link,:url_heading
  has_many :link_users, foreign_key: "link_id", dependent: :destroy
  has_many :users, through: :link_users, source: :user

  has_many :comments, dependent: :destroy

  validates :url_link, uniqueness: true
  default_scope order: 'links.created_at DESC'


  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    joins(:users).where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id).uniq
  end
end
