# == Schema Information
#
# Table name: downvotes
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  votable_id   :integer
#  votable_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Downvote < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :votable_id, :user_id

  belongs_to :votable, polymorphic: true, touch: true
  belongs_to :user

  validates :user_id, presence: true

  after_save :calculate_score

  def calculate_score
    if self.votable.is_a? LinkUser
      LinkScoreWorker.perform_async(self.votable.id)
    end
  end
end
