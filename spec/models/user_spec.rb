# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  email               :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  password_digest     :string(255)
#  remember_token      :string(255)
#  admin               :boolean          default(FALSE)
#  slug                :string(255)
#  uid                 :string(255)
#  oauth_token         :string(255)
#  oauth_expires_at    :datetime
#  username            :string(255)
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  description         :text
#


require 'spec_helper'

describe User do

  before { @user = User.new(name: "Example User", email: "sample@example.com", password: "foobar", password_confirmation: "foobar" )}

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }

  it { should be_valid }

  describe "when name is not present" do
    before { @user.name= " " }
    it { should_not be_valid } 
  end

  describe "when email is not present" do
    before { @user.email= " "}
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end  

  describe "when email format is invalid" do

    it "should be invalid" do

      addresses = %w[vysakh@exam,com vysaexam@sam. vysa_at_foo.com vysk@jk+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
   end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM ab_ae-ex@sam.com vysa.ke@fefkdf.com kd+dk@ksmf.com]

      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  describe "when email address is already taken" do

    before do
      user_with_same_email = @user.dup
      user_with_same_email.save
    end

    it { should_not be_valid }
  end
 describe "when password is empty" do

   before { @user.password = @user.password_confirmation = " " }
   it { should_not be_valid }
 end

 describe "when password does not match" do
   before { @user.password_confirmation = "mismatch" }
   it { should_not be_valid }
 end

 describe "when password is nil" do

   before { @user.password_confirmation = nil } 
   it { should_not be_valid }
 end

 describe "return value of authentication method" do

   before { @user.save }
   let(:found_user) { User.find_by_email(@user.email) }

   describe "With valid password" do
     it { should == found_user.authenticate(@user.password) }
   end

   describe "with invalid password" do
     let(:user_for_invalid_password) { found_user.authenticate("invalid") }

     it { should_not == user_for_invalid_password }
     specify { user_for_invalid_password.should be_false }
   end
   
 end

 describe "with a password that's too short" do
   before { @user.password = @user.password_confirmation = "a" * 5 }
   it { should_not be_valid }
 end

 describe "remember token" do
   before { @user.save }
   it { @user.remember_token.should_not be_blank }
 end

end
