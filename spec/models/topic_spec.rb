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
