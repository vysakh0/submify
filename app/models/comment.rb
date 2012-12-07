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

  has_attached_file :avatar, styles: { medium: "600x600>", thumb: "300x300>" }
  belongs_to :commentable, polymorphic: true  
  belongs_to :user
  has_many :flags, as: :flaggable
  has_many :comment_downvotes, dependent: :destroy
  has_many :comments, as: :commentable
  validates :user_id, presence: true
  has_many :votes, as: :votable, dependent: :destroy

end
