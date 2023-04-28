FactoryBot.define do
  factory :task, class: Task do
    description { "My description" }
    date { Time.zone.now }

    trait :done do
      done { true }
    end
  end
end