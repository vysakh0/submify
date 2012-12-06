class CommentDownvote < ActiveRecord::Base
  attr_accessible :comment_id, :user_id

  belongs_to :user
  belongs_to :comment

  validates :user_id, presence: true
end
