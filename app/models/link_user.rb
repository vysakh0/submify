# == Schema Information
#
# Table name: link_users
#
#  id         :integer          not null, primary key
#  link_id    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class LinkUser < ActiveRecord::Base

  attr_accessible :link_id, :user_id

  belongs_to :link, class_name: "Link"
  belongs_to :user, class_name: "User"

  default_scope order: 'link_users.created_at DESC'

  validates :user_id, presence: true
  validates :link_id, presence: true

end
