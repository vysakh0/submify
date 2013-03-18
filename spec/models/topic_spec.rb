# == Schema Information
#
# Table name: topics
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :text
#  slug                :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  verify              :boolean          default(FALSE)
#

require 'spec_helper'

describe Topic do
  before(:all) do
    @topic = FactoryGirl.build(:topic) 
  end
  
  it "should be able to return similar matches" do
  	matched_results = Topic.search(@topic.name)
  	matched_results.each do |result|
  		result['label'].should == @topic.name
  		result['value'].should == @topic.name
  	end
  end
end
