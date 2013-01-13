class Notification < ActiveRecord::Base
  attr_accessible :notifiable_id, :notifiable_type, :parent_id, :parent_type

  attr_accessible :user_id
  belongs_to :user
  belongs_to :notifiable, polymorphic: true
  belongs_to :parent, polymorphic: true
  validates :user_id, presence: true
  after_save :update_counter

  def update_counter
    notify = Notification.where("updated_at > ?", user.notify).count  
    user.update_column(:notifications_count, notify)
  end 
end
