class Vote < ActiveRecord::Base
  attr_accessible :votable_id, :user_id

  belongs_to :votable, polymorphic: true, touch: true
  belongs_to :user

  validates :user_id, presence: true
 
  after_initialize :calculate_score

  def calculate_score
    if votable.is_a? Link
      votable.calculate_score
    elsif votable.is_a? Comment
      votable.calculate_score
    end
  end
end
