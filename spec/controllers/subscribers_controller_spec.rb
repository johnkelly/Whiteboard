require 'spec_helper'

describe SubscribersController do
  let(:subscription) { create(:basic_subscription) }
  let(:user) { subscription.user }
  before { sign_in user }

  describe "show" do
    before { get :show }
    it { should assign_to(:subscriber).with(user.subscriber) }
    it { should assign_to(:users).with(user.subscriber.users) }
    # it { should assign_to(:subscription).with(subscription) }
    # it { should assign_to(:whiteboards).with(subscription.drawings) }
    it { should respond_with(:success) }
  end
end