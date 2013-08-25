require 'spec_helper'

describe Customer::DashboardController do
  sign_in_as_customer

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end
end
