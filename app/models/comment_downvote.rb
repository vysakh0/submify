class CommentDownvote < ActiveRecord::Base
  attr_accessible :comment_id, :user_id

  belongs_to :user
  belongs_to :comment, touch: true

  validates :user_id, presence: true
  after_initialize :calculate_score

  def calculate_score
    comment.calculate_score if comment
  end
end
