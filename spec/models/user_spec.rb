require 'spec_helper'

describe User do
  
  it "can verify a new user without sending a mail" do
  	user = User.create!({:name => 'Saurav C', :email => 'csaurav80@gmail.com', :password => 'Submify@12345', 
  		:password_confirmation => 'Submify@12345'})
  	expect(user.verify).to eq false
	user.confirm_user
	expect(user.verify).to eq true
  end
end
