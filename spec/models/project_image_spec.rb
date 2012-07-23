require 'spec_helper'

describe ProjectImage do
  describe "attributes" do
    it { should validate_presence_of(:project_id) }
    it { should validate_presence_of(:canvas) }

    it { should belong_to(:project) }
    it { should_not allow_mass_assignment_of(:project_id) }
  end
end