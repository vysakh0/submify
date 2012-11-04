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
  attr_accessible :body

  belongs_to :commentable, polymorphic: true  
  belongs_to :user

  has_many :comments, as: :commentable
  validates :user_id, presence: true
 
end
