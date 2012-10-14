FactoryGirl.define do
  factory :subscription do |f|
    association :user, factory: :subscriber_user
    association :subscriber

    trait :tier_1 do
      plan_id 1
    end

    trait :tier_2 do
      plan_id 2
    end

    trait :tier_3 do
      plan_id 3
    end

    factory :basic_subscription, traits: [:tier_1]
    factory :professional_subscription, traits: [:tier_2]
    factory :elite_subscription, traits: [:tier_3]

    after(:create) do |subscription|
      subscription.drawings << FactoryGirl.create(:drawing, subscription: subscription)
    end
  end
end