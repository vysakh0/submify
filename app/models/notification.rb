class Notification < ActiveRecord::Base
  attr_accessible :notifiable_id, :notifiable_type, :parent_id, :parent_type

  attr_accessible :user_id
  belongs_to :user
  belongs_to :notifiable, polymorphic: true
  belongs_to :parent, polymorphic: true
  validates :user_id, presence: true
  after_save :inc_counter
  before_destroy :dec_counter

  def inc_counter
    user.update_column(:notifications_count, user.notifications_count + 1)
  end 
  def dec_counter
    user.update_column(:notifications_count, user.notifications_count - 1)
  end 
end
