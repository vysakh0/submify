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
  after_create :score_and_notify
  has_many :notifications, as: :notifiable, dependent: :destroy

  def score_and_notify
    if votable.is_a? LinkUser
      link_user_score(votable)

    else 
      comment_score(votable)
    end
    notify = Notification.where(notifiable_type: "Vote" , user_id: votable.user.id, parent_id: votable_id, parent_type: votable_type).first_or_initialize
    notify.notifiable_id = id
    notify.save!
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
      score =  x
    elsif x>=1
      score = (C * Math::log10(x+1) ) +  score #-> this is reddit algorithm
    end
    link_user.update_column(:score, score)
  end
end
