# == Schema Information
#
# Table name: link_users
#
#  id         :integer          not null, primary key
#  link_id    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  topic_id   :integer
#  score      :integer
#

class LinkUser < ActiveRecord::Base

  attr_accessible :link_id, :user_id, :topic_id

  belongs_to :link, class_name: "Link", touch: true
  belongs_to :user, class_name: "User", touch: true
  belongs_to :topic, class_name: "Topic", touch: true
  has_many :votes, as: :votable, dependent: :destroy
  has_many :downvotes,as: :votable, dependent: :destroy

  default_scope order: 'link_users.created_at DESC'

  validates :link_id, presence: true
  after_create :calculate_score

  def calculate_score
    self.update_column(:score, self.created_at.to_i)
  end

  def self.from_users_followed_by(user)
    followed_topic_ids = "SELECT topic_id FROM topic_user_relationships WHERE user_id = :user_id"
    followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    where("topic_id IN (#{followed_topic_ids}) OR  user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id).uniq
  end
end
