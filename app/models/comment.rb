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
  attr_accessible :body, :avatar
  self.per_page = 10

  has_attached_file :avatar, styles: { medium: ["600x600>", :jpg] }

  belongs_to :commentable, polymorphic: true, touch: true 
  belongs_to :user, touch: true 
  has_many :flags, as: :flaggable
  has_many :downvotes,as: :votable, dependent: :destroy
  has_many :comments, as: :commentable
  has_many :notifications, as: :notifiable, dependent: :destroy
  validates :user_id, presence: true
  has_many :votes, as: :votable, dependent: :destroy
  after_save :calculate_score

  def calculate_score
    if self.commentable.is_a? Link
      CommentScoreWorker.perform_async(self.id)
    end
  end

  def user_name
    user.user_name
  end
end
