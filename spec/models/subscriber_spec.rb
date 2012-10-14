require 'spec_helper'

describe Subscriber do
  describe "attributes" do
    it { should have_many(:users).dependent(:destroy) }
    it { should have_one(:subscription).dependent(:destroy) }
  end
end