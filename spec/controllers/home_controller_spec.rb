require 'spec_helper'

describe HomeController do

  describe "GET 'root'" do
    it "returns http success" do
      get 'root'
      response.should be_success
    end
  end

end
