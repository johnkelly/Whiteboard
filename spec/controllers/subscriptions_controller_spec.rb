require 'spec_helper'

describe SubscriptionsController do
  include Devise::TestHelpers
  
  before do
    @customer = User.new(email: "test@example.com", password: "password", password_confirmation: "password")
    @customer.stripe_customer_token = "C12345"
    @customer.save!
    sign_in @customer
  end

  describe "#create" do
    context "Add First Subscription" do
      it "creates a new subscription" do
        lambda do
          post :create, plan_id: 1
        end.should change(Subscription, :count).by(1)

        response.should redirect_to root_url
      end

      it "fails if no plan provided" do
        lambda do
          post :create
        end.should_not change(Subscription, :count)

        response.should redirect_to plans_url
      end
    end

    context "Change Subscription" do
      before { @subscription = @customer.build_subscription(plan_id: 1)
      @subscription.save! }

      it "updates current subscription" do
        lambda do
          post :create, plan_id: 3
        end.should_not change(Subscription, :count)
  
        @subscription.reload.plan_id.should == 3
        response.should redirect_to root_url
      end

      it "fails if no plan provided" do
        lambda do
          post :create
        end.should_not change(Subscription, :count)

        @subscription.reload.plan_id.should == 1
        response.should redirect_to plans_url
      end
    end
  end

  describe "#destroy" do
    it "destroys a subscription" do
      @subscription = @customer.build_subscription(plan_id: 1)
      @subscription.save!

      lambda do
        delete :destroy, id: @subscription.to_param
      end.should change(Subscription, :count).by(-1)

      response.should redirect_to root_url
    end 
  end
end