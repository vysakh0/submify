class LinkUser < ActiveRecord::Base

  attr_accessible :link_id, :user_id

  belongs_to :link, class_name: "Link"
  belongs_to :user, class_name: "User"


  validates :user_id, presence: true
  validates :link_id, presence: true

end
