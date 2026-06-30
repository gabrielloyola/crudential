FactoryBot.define do
  factory :registration do
    association :event
    association :participant
    status { "pending" }
    confirmed_at { nil }

    trait :confirmed do
      status { "confirmed" }
      confirmed_at { Time.current }
    end

    trait :cancelled do
      status { "cancelled" }
    end
  end
end
