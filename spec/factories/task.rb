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

    trait :with_two_sub_tasks do
      after(:create) do |task|
        2.times do
          sub_task = create(:task)
          sub_task.parent_id = task.id
          sub_task.save
        end
      end
    end

    trait :with_at_least_one_completed_subtask do
      after(:create) do |task|
        sub_task_one = create(:task)
        sub_task_one.parent_id = task.id
        sub_task_one.done = true
        sub_task_one.save

        sub_task_two = create(:task)
        sub_task_two.parent_id = task.id
        sub_task_two.save
      end
    end
  end
end