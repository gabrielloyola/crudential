FactoryBot.define do
  factory :participant do
    name { "Grace Hopper" }
    sequence(:email) { |n| "participant#{n}@example.com" }
    sequence(:document_number) { |n| format("%011d", n) }
  end
end
