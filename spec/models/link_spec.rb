# == Schema Information
#
# Table name: links
#
#  id                  :integer          not null, primary key
#  url_link            :string(255)
#  url_heading         :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#

require 'spec_helper'

describe Link do
  pending "add some examples to (or delete) #{__FILE__}"
end
