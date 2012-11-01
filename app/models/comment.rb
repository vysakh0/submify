class Comment < ActiveRecord::Base
  attr_accessible :body

  belongs_to :link  
  validates :link_id, presence: true 

 
end
