require 'spec_helper'

describe Subscription do
  let(:user) { create(:subscriber_user) }
  let!(:subscription) { create(:basic_subscription, subscriber: user.subscriber) }

  describe "attributes" do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:plan_id) }
    it { should validate_presence_of(:subscriber_id) }

    it { should validate_uniqueness_of(:user_id) }
    it { should validate_uniqueness_of(:subscriber_id) }

    it { should belong_to(:user) }
    it { should belong_to(:subscriber) }
    it { should have_many(:drawings).dependent(:destroy) }
    it { should_not allow_mass_assignment_of(:subscriber_id) }
  end

  describe "update_stripe_subscription" do
    pending "test stripe"

    it "should be called on save" do
      subscription.should_receive(:update_stripe_subscription)
      subscription.save!
    end
  end

  describe "cancel_stripe_subscription" do
    pending "test stripe"

    it "should be called on destroy" do
      subscription.should_receive(:cancel_stripe_subscription)
      subscription.destroy
    end
  end

  describe "plan_name" do
    it "returns basic for plan 1" do
      subscription.plan_name.should == "Starter"
    end

    it "returns professional for plan 2" do
      subscription.plan_id = 2
      subscription.save!

      subscription.plan_name.should == "Small Business"
    end

    it "returns elite for plan 3" do
      subscription.plan_id = 3
      subscription.save!

      subscription.plan_name.should == "Enterprise"
    end
  end

  describe "plan_allowed_users" do
    it "returns 5 for plan 1" do
      subscription.plan_allowed_users.should == 5
    end

    it "returns 25 for plan 2" do
      subscription.plan_id = 2
      subscription.save!

      subscription.plan_allowed_users.should == 25
    end

    it "returns 125 for plan 3" do
      subscription.plan_id = 3
      subscription.save!

      subscription.plan_allowed_users.should == 125
    end
  end

  describe "plan_allowed_whiteboards" do
    it "returns 500 for plan 1" do
      subscription.plan_allowed_whiteboards.should == 500
    end

    it "returns 5000 for plan 2" do
      subscription.plan_id = 2
      subscription.save!

      subscription.plan_allowed_whiteboards.should == 5000
    end

    it "returns 50000 for plan 3" do
      subscription.plan_id = 3
      subscription.save!

      subscription.plan_allowed_whiteboards.should == 50000
    end
  end

  describe "check_user_limit" do
    context "does not save the subscription" do
      it "returns false" do
        subscription.subscriber.users.should_receive(:size).and_return(6)
        subscription.should_receive(:plan_allowed_users).and_return(5)
        subscription.save.should be_false
      end
    end

    context "saves the subscription" do
      it "returns true" do
        subscription.subscriber.users.should_receive(:size).and_return(4)
        subscription.should_receive(:plan_allowed_users).and_return(5)
        subscription.save.should be_true
      end
    end
  end
end