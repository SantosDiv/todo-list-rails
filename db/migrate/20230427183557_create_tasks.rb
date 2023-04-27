class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :description, null: false
      t.boolean :done, default: false, null: false
      t.date :date

      t.timestamps
    end
  end
end
