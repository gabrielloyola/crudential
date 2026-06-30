FactoryBot.define do
  factory :user do
    name { "Ada Lovelace" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "super-secret" }
    role { "staff" }
  end
end
