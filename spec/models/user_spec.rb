require 'spec_helper'

describe User do
  before do
    @user = User.create!(email: "test@example.com", password: "password", password_confirmation: "password")
  end
  describe "save_stripe_customer" do
    pending "mocking Stipe::Customer"
  end

  describe "delete_stripe_customer" do
    it "is called on destroy when user has stripe_customer_token" do
      @user.stripe_customer_token = "C12345"
      @user.save!
      @user.should_receive(:delete_stripe_customer)
      @user.destroy
    end
  end
end
