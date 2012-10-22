require 'spec_helper'

describe LinksController do

  describe "GET 'url_link:string'" do
    it "returns http success" do
      get 'url_link:string'
      response.should be_success
    end
  end

  describe "GET 'url_heading:string'" do
    it "returns http success" do
      get 'url_heading:string'
      response.should be_success
    end
  end

end
