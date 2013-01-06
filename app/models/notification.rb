class Notification < ActiveRecord::Base
  attr_accessible :notifiable_id, :notifiable_type, :parent_id, :parent_type

  attr_accessible :user_id
  belongs_to :user
  belongs_to :notifiable, polymorphic: true
  belongs_to :parent, polymorphic: true
  validates :user_id, presence: true
end
