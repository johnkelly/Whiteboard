require 'spec_helper'

describe CustomersController do
  let(:user) { create(:trial_user) }
  before { sign_in user }

  describe "#new" do
    before { get :new }
    it { should respond_with(:success) }
  end

  describe "#create" do
    context "Add Billing Info for first time" do
      before {post :create, customer: { stripe_card_token: "12345"} }
      it { should set_the_flash[:analytics].to("/vp/add_credit_card") }
      it { should set_the_flash[:notice] }
      it { should redirect_to(plans_url)}
    end

    context "Update Billing Info" do
      it "modifies the credit card but doesn't create a new customer" do
        user.stripe_customer_token = "C12345"
        user.save!
        post :create, customer: { stripe_card_token: "12345" }
        user.reload.stripe_customer_token.should == "C12345"
      end
    end
  end
end