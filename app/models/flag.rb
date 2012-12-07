class Flag < ActiveRecord::Base
  attr_accessible :user_id
  belongs_to :user
  belongs_to :flaggable, polymorphic: true
  validates :user_id, presence: true
end
