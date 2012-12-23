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
#

class Comment < ActiveRecord::Base
  attr_accessible :body, :avatar
  self.per_page = 10

  has_attached_file :avatar, styles: { medium: "600x600>", thumb: "300x300>" }
  belongs_to :commentable, polymorphic: true, touch: true 
  belongs_to :user, touch: true 
  has_many :flags, as: :flaggable
  has_many :comment_downvotes, dependent: :destroy
  has_many :comments, as: :commentable
  after_save :add_downvote 
  validates :user_id, presence: true
  has_many :votes, as: :votable, dependent: :destroy
  C = 45000
  EPOCH = 1356264052 #time in milli seconds 23rd dec 5.31 PM
  def calculate_score
    if self.commentable.is_a? Link
      t = (self.created_at.to_i - EPOCH)
      x = self.votes.count + self.comments.count - self.comment_downvotes.count  #number of upvotes only
      self.score = x+1 +  t
    end
  end

  def add_downvote
    if self.commentable.is_a? Link
      vote =CommentDownvote.new(user_id: 0, comment_id: id) 
      vote.save
    end
  end
  def user_name
    user.user_name
  end

  def self.show_link_comments link_id
    where("commentable_id = #{link_id}").joins(:comment_downvotes).group("comments.id").order("count(*)")
  end

end
