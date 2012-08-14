FactoryGirl.define do
  factory :project_image do |f|
    f.canvas { File.open(File.join(Rails.root, 'spec', 'fixtures', 'files', 'rails.png')) }
    f.association :project, factory: :project
  end
end