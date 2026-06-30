FactoryBot.define do
  factory :credential do
    association :registration
    status { "active" }
    issued_at { Time.current }
    expires_at { issued_at + 1.day }

    trait :revoked do
      status { "revoked" }
    end

    trait :expired do
      status { "expired" }
    end
  end
end
