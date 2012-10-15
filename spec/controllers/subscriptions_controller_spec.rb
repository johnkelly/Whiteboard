require 'spec_helper'

describe SubscriptionsController do
    let(:subscription) { create(:basic_subscription) }
    let(:user) { create(:subscriber_user, subscriber: subscription.subscriber) }

  describe "#create" do
    context "Add First Subscription" do
      before { sign_in create(:customer) }

      it "creates a new subscription" do
        -> { post :create, plan_id: 1 }.should change(Subscription, :count).by(1)
        response.should redirect_to whiteboards_url
      end

      it "fails if no plan provided" do
        -> { post :create }.should_not change(Subscription, :count)
        response.should redirect_to plans_url
      end
    end

    context "Sets Analytic Code for Creation" do
      before do
       sign_in create(:customer)
       -> { post :create, plan_id: 1 }.should change(Subscription, :count).by(1)
      end

      it { should set_the_flash[:analytics].to("/vp/add_subscription") }
    end

    context "Change Subscription" do
      before { sign_in user }

      it "updates current subscription" do
        user.subscription.present?.should be_true

        -> { post :create, plan_id: 3 }.should_not change(Subscription, :count)

        subscription.reload.plan_id.should == 3
        response.should redirect_to whiteboards_url
      end

      it "fails if no plan provided" do
        -> { post :create }.should_not change(Subscription, :count)

        subscription.reload.plan_id.should == 1
        response.should redirect_to plans_url
      end
    end
  end

  describe "#destroy" do
    before { sign_in user }

    it "destroys a subscription" do
      -> { delete :destroy, id: subscription.to_param }.should change(Subscription, :count).by(-1)
      response.should redirect_to root_url
    end

    context "Sets Analytic Code for Deletion" do
      before { -> { delete :destroy, id: subscription.to_param }.should change(Subscription, :count).by(-1) }
      it { should set_the_flash[:analytics].to("/vp/cancel_subscription") }
    end
  end
end