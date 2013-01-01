# == Schema Information
#
# Table name: votes
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  votable_id   :integer
#  votable_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Vote < ActiveRecord::Base
  attr_accessible :votable_id, :user_id

  belongs_to :votable, polymorphic: true, touch: true
  belongs_to :user

  validates :user_id, presence: true
  after_save :calculate_score
  has_many :notifications, as: :notifiable, dependent: :destroy

  def calculate_score
    if self.votable.is_a? LinkUser
      LinkScoreWorker.perform_async(self.votable.id) 
    else 
      CommentScoreWorker.perform_async(self.votable.id)
    end
  end

  def user_to_notify
    self.votable.user.id
  end

end
