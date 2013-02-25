# == Schema Information
#
# Table name: flags
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  flaggable_id   :integer
#  flaggable_type :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Flag < ApplicationModel
  attr_accessible :user_id
  belongs_to :user
  belongs_to :flaggable, polymorphic: true
  validates :user_id, presence: true
end
