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

  after_create :score_and_notify
  def score_and_notify
    if self.votable.is_a? LinkUser
      link_user_score(self.votable)

    else 
      comment_score(self.votable)
    end
  end


  private 

  C = 45000
  def comment_score(comment)
    x = comment.votes.count  - comment.downvotes.count  #number of upvotes only
    if x <= 0
      score =  x
    else
      score = (C * Math::log10(x + 1)) + comment.created_at.to_i 
    end
    comment.update_column(:score, score)

  end
  def link_user_score(link_user)
    score = link_user.created_at.to_i #time is the default score 
    x = link_user.votes.count - link_user.downvotes.count 
    if x< 0 
      score =  score + ( C* x)
    elsif x>=1
      score = (C * Math::log10(x+1) ) +  score #-> this is reddit algorithm
    end
    link_user.update_column(:score, score)
  end
end

