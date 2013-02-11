# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Relationship < ActiveRecord::Base
  attr_accessible :followed_id
  belongs_to :follower, class_name: "User", touch: true
  has_many :notifications, as: :parent, dependent: :destroy
  belongs_to :followed, class_name: "User", touch: true, counter_cache: true

  validates :follower_id, presence: true
  validates :followed_id, presence: true
  after_save :notify


  def notify
      Notification.create!(notifiable_id: follower_id , notifiable_type: "User", user_id: followed_id, parent_id: id, parent_type: "Relationship")
  end
end
