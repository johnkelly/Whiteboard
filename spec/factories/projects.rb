FactoryGirl.define do
  factory :project do |f|
    name "Test Project"
    f.association :subscription, factory: :basic_subscription
  end
end