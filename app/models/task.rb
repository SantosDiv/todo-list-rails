class Task < ApplicationRecord
  validates :description, presence: true
  validates :done, inclusion: [true, false]

  belongs_to :parent, class_name: 'Task', optional: true
  has_many :sub_tasks, class_name: 'Task', foreign_key: :parent_id, dependent: :destroy

  scope :only_parent, -> { where(parent_id: nil) }
end