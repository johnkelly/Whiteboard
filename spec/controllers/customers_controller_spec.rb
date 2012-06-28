require 'spec_helper'

describe CustomersController do
  include Devise::TestHelpers
  
  before do
    @user = User.create!(email: "test@example.com", password: "password", password_confirmation: "password")
    sign_in @user
  end

  describe "#new" do
    before { get :new }
    it { should respond_with(:success) }
  end

  describe "#create" do
    context "Add Billing Info for first time" do
      before {post :create, customer: { stripe_card_token: "12345"} }
      it { should set_the_flash }
      it { should redirect_to(root_url)}
    end
    
    context "Update Billing Info" do
    end
  end
end