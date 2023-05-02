class Task < ApplicationRecord
  validates :description, presence: true
  validates :done, inclusion: [true, false]

  belongs_to :parent, class_name: 'Task', optional: true
  has_many :sub_tasks, -> { order("date") }, class_name: 'Task', foreign_key: :parent_id, dependent: :destroy

  scope :only_parent, -> { where(parent_id: nil) }

  scope :filter_by, -> (date:) {
    where(date: date.beginning_of_day..date.end_of_day, parent_id: nil)
    .order(date: :asc)
  }

  def sub_task?
    !self.parent_id.nil?
  end

  def parent?
    self.parent_id.nil?
  end

  def all_sub_task_done?
    return if sub_task?
    self.sub_tasks.all?(&:done?)
  end

  def has_sub_task?
    !self.sub_tasks.empty?
  end

  def change_parent_status!
    status = false
    status = true if self.all_sub_task_done?

    self.update(done: status)
  end
end