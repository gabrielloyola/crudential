FactoryBot.define do
  factory :access_log do
    credential
    registration { credential.registration }
    result { "denied" }
    attempted_at { Time.current }

    trait :granted do
      result { "granted" }
    end
  end
end
