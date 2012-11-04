# == Schema Information
#
# Table name: links
#
#  id          :integer          not null, primary key
#  url_link    :string(255)
#  url_heading :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string(255)
#

require 'spec_helper'

describe Link do
  pending "add some examples to (or delete) #{__FILE__}"
end
