# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  body             :text
#  user_id          :integer
#  commentable_id   :integer
#  commentable_type :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  score            :integer
#

class Comment < ActiveRecord::Base
  attr_accessible :body 
  self.per_page = 10
  belongs_to :commentable, polymorphic: true, touch: true, counter_cache: true
  belongs_to :user, touch: true, counter_cache: true
  has_many :flags, as: :flaggable
  has_many :downvotes,as: :votable, dependent: :destroy
  has_many :comments, as: :commentable
  has_many :notifications, as: :parent, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy
  validates :user_id, presence: true
  has_many :votes, as: :votable, dependent: :destroy
  after_create :score_and_notify

  def score_and_notify
    update_column(:score, (created_at.to_i/60))
    if commentable.is_a? Comment
      notify = Notification.where(notifiable_type: "Comment" , user_id: commentable.user.id, parent_id: commentable_id, parent_type: "Comment").first_or_initialize
      notify.notifiable_id = id
      notify.save!
    end
  end


  def user_name
    user.user_name
  end
end
