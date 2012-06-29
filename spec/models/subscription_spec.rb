require 'spec_helper'

describe Subscription do
  before do
    @customer = User.new(email: "test@example.com", password: "password", password_confirmation: "password")
    @customer.stripe_customer_token = "C12345"
    @customer.save!

    @subscription = @customer.build_subscription(plan_id: 1)
    @subscription.save!
  end

  describe "attributes" do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:plan_id) }
    it { should validate_uniqueness_of(:user_id) }

    it { should belong_to(:user) }
    it { should_not allow_mass_assignment_of(:user_id) }
  end

  describe "update_stripe_subscription" do
    pending "test stripe" 
    
    it "should be called on save" do
      @subscription.should_receive(:update_stripe_subscription)
      @subscription.save!
    end
  end

  describe "cancel_stripe_subscription" do
    pending "test stripe" 
    
    it "should be called on destroy" do
      @subscription.should_receive(:cancel_stripe_subscription)
      @subscription.destroy
    end
  end

  describe "plan_name" do
    it "returns basic for plan 1" do
      @subscription.plan_name.should == "Basic"
    end
    
    it "returns professional for plan 2" do
      @subscription.plan_id = 2
      @subscription.save!

      @subscription.plan_name.should == "Professional"
    end
    
    it "returns elite for plan 3" do
      @subscription.plan_id = 3
      @subscription.save!

      @subscription.plan_name.should == "Elite"
    end   
  end
end