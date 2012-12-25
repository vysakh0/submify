class Downvote < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :votable_id, :user_id

  belongs_to :votable, polymorphic: true, touch: true
  belongs_to :user

  validates :user_id, presence: true

  after_save :calculate_score

  def calculate_score
    self.votable.calculate_score
  end
end
