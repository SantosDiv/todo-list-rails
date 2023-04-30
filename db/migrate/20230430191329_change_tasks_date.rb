class ChangeTasksDate < ActiveRecord::Migration[6.1]
  def change
    change_column :tasks, :date, :datetime
  end
end
