FactoryBot.define do
  factory :event do
    association :user
    name { "RailsConf" }
    description { "A conference for Rails developers." }
    starts_at { 1.week.from_now }
    ends_at { starts_at + 2.days }
    capacity { 100 }
    status { "draft" }
  end
end
