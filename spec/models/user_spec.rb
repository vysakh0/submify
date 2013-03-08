require 'spec_helper'

describe User do

  before(:all) do
    @user = FactoryGirl.build(:user) 
  end
  it "can verify a new user without sending a mail" do
  	@user.verify.should be_false
  	@user.confirm_user
  	@user.verify.should be_true
  end

  it "should be able to return similar matches" do
  	matched_results = User.search(@user.name)
  	matched_results.each do |result|
  		result['label'].should == @user.name
  		result['value'].should == @user.name
  	end
  end

end
