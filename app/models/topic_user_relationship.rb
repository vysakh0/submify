# == Schema Information
#
# Table name: topic_user_relationships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  topic_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TopicUserRelationship < ActiveRecord::Base
  attr_accessible :topic_id, :user_id
  belongs_to :topic, class_name: "Topic"
  belongs_to :user, class_name: "User"

  validates :user_id, presence: true
  validates :topic_id, presence: true
end
