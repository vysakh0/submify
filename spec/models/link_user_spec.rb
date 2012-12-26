# == Schema Information
#
# Table name: link_users
#
#  id         :integer          not null, primary key
#  link_id    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  topic_id   :integer
#  score      :integer
#

require 'spec_helper'

describe LinkUser do
  pending "add some examples to (or delete) #{__FILE__}"
end
