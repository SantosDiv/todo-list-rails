class Task < ApplicationRecord
  validates :description, presence: true
  validates :done, inclusion: [true, false]

  belongs_to :parent, class_name: 'Task', optional: true
  has_many :sub_tasks, -> { order("date") }, class_name: 'Task', foreign_key: :parent_id, dependent: :destroy

  scope :only_parent, -> { where(parent_id: nil) }

  scope :filter_by_date, -> (start_date:, end_date:) { where(date: start_date..end_date, parent_id: nil) }

  scope :only_today, -> {
    where(date: Time.zone.today.beginning_of_day..Time.zone.today.end_of_day, parent_id: nil)
    .order(date: :asc)
  }

  scope :only_tomorrow, -> {
    where(date: Time.zone.tomorrow.beginning_of_day..Time.zone.tomorrow.end_of_day, parent_id: nil)
    .order(date: :asc)
  }

  def has_sub_task?
    !self.sub_tasks.empty?
  end
end