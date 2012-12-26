# == Schema Information
#
# Table name: topic_user_relationships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  topic_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe TopicUserRelationship do
  pending "add some examples to (or delete) #{__FILE__}"
end
