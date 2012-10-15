require 'spec_helper'

describe SubscribersController do
  let(:subscription) { create(:basic_subscription) }
  let(:user) { create(:subscriber_user, subscriber: subscription.subscriber) }

  before { sign_in user }

  describe "show" do
    before { get :show }
    it { should assign_to(:subscriber).with(user.subscriber) }
    it { should assign_to(:users).with(user.subscriber.users) }
    # it { should assign_to(:subscription).with(subscription) }
    # it { should assign_to(:whiteboards).with(subscription.drawings) }
    it { should respond_with(:success) }
  end

  describe "add_user" do
    context "success" do
      before { post :add_user, user: { email: "random@example.com", password: "password" }}
      it { should assign_to(:subscriber).with(user.subscriber) }
      it { should assign_to(:user).with(be_a_new_record) }
      it { should set_the_flash[:notice] }
      it { should redirect_to subscribers_url }
    end

    context "error" do
      before { post :add_user, user: { }}
      it { should assign_to(:subscriber).with(user.subscriber) }
      it { should assign_to(:user).with(be_a_new_record) }
      it { should set_the_flash[:alert] }
      it { should redirect_to subscribers_url }
    end
  end
end