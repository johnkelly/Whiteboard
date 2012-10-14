FactoryGirl.define do
  factory :user do
    password 'password'
    password_confirmation 'password'

    trait :trial_user do
      sequence(:email) {|n| "trial#{n}@example.com" }
    end

    trait :customer do
      association :subscriber
      sequence(:email) {|n| "customer#{n}@example.com" }
      stripe_customer_token 'C12345'
    end

    trait :subscriber_user do |f|
      association :subscriber
      sequence(:email) {|n| "subscriber#{n}@example.com" }
    end

    factory :trial_user, traits: [:trial_user]
    factory :customer, traits: [:customer]
    factory :subscriber_user, traits: [:customer, :subscriber_user]
  end
end
