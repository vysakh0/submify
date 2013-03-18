require 'spec_helper'

describe User do

  before(:each) do
    @user = FactoryGirl.build(:user) 
  end

  it "is valid with proper values" do
    @user.valid?.should be_true
  end

  it "is invalid without a name" do
      @user.name = nil
      @user.should_not be_valid
  end

  it "is invalid without a email" do
      @user.email = nil
      @user.should_not be_valid
  end

  it "is invalid without a password" do
      @user.password = nil
      @user.should_not be_valid
  end  

  it "is invalid without a password_confirmation" do
      @user.password_confirmation = nil
      @user.should_not be_valid
  end  

  it "is invalid when password and password_confirmation do not match" do
      @user.password = 'password'
      @user.password_confirmation = 'differentpassword'
      @user.should_not be_valid
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

  it { should have_many(:flags) }

  it { should have_many(:topic_user_relationships).dependent(:destroy)}

  after(:each) do
    @user.delete
  end

end
