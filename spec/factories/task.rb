FactoryBot.define do
  factory :task, class: Task do
    description { "My description" }
    date { Time.zone.now }

    trait :done do
      done { true }
    end

    trait :with_sub_task do
      after(:create) do |task|
        sub_task = create(:task)
        sub_task.parent_id = task.id
        sub_task.save
      end
    end
  end
end