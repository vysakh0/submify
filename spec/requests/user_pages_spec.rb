require 'spec_helper'

describe "UserPages" do

  subject { page }

   describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

   describe "with invalid information" do
    it "should not create a user" do
     expect { click_button submit}.not_to chage(User, :count)
    end
   end

   describe "with valid information" do
     before do
       fill_in "Name", with: "Example User"
       fill_in "Email", with: "user@example.com"
       fill_in "Password", with: "foobar"
       fill_in "Confirmation", with: "foobar"
     end

       it "should create a user" do
         expect { click_button submit}.to change(User, :count).by(1)
       end
      end
   end

   describe "edit" do
     let(:user) { FactoryGirl.create(:user) }
      before { visit edit_user_path(user) }

      describe "page" do
        it { should have_selector('h3', text: "Update your profile") }
        it { should have_selector('title', text: "Edit User") }
        it { should have_link('change', href: 'http://gravatar.com/emails' ) }
      end

      describe "with invalid information" do
        before { click_button "Save changes" }
        it { should have_content('error') }
      end
    end

end
