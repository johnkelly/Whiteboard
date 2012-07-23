require 'spec_helper'

describe Project do
  describe "attributes" do
    it { should validate_presence_of(:subscription_id) }
    it { should validate_presence_of(:name) }

    it { should belong_to(:subscription) }
    it { should have_many(:project_images).dependent(:destroy) }
    it { should_not allow_mass_assignment_of(:subscription_id) }
    it { should ensure_length_of(:name).is_at_most(50) }
  end
end