require 'spec_helper'

describe Subscriber do
  describe "attributes" do
    it { should have_many(:users).dependent(:destroy) }
    it { should have_one(:subscription).dependent(:destroy) }
  end

  describe "trial?" do
    let!(:subscription) { create(:basic_subscription) }

    it "returns true if plan is 1 and subscriber is less than a month old" do
      subscription.subscriber.stub(:created_at).and_return(1.day.ago.to_time)
      subscription.subscriber.trial?.should be_true
    end

    it "returns fase if subscriber is more than a month old" do
      subscription.subscriber.stub(:created_at).and_return(30.days.ago.to_time)
      subscription.subscriber.trial?.should be_false
    end
  end

  describe "days_left_in_trial" do
    let!(:subscription) { create(:basic_subscription) }

    it "returns the number of days before the trial expires" do
      subscription.subscriber.stub(:created_at).and_return(1.day.ago.to_time)
      subscription.subscriber.days_left_in_trial.should == 29
    end
  end
end