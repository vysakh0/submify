class TopicDownvote < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :topic_id, :user_id, :link_id

  belongs_to :topic
  belongs_to :user
  belongs_to :link

  validates :user_id, presence: true

end
