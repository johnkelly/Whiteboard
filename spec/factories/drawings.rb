FactoryGirl.define do
  factory :drawing do |f|
    f.association :subscription, factory: :basic_subscription
    f.canvas { File.open(File.join(Rails.root, 'spec', 'fixtures', 'files', 'empty_canvas.png')) }
  end
end