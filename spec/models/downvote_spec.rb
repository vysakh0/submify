# == Schema Information
#
# Table name: downvotes
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  votable_id   :integer
#  votable_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Downvote do
  pending "add some examples to (or delete) #{__FILE__}"
end
