class UpdateTask < TasksManager
  def execute(task_model:)
    @old_task_date = task_model.date.to_date

    task_model.update(@task_params)

    update_date_subtasks(parent_task_updated: task_model) if task_model.parent?

    task_model
  end

  private

  def update_date_subtasks(parent_task_updated:)
    return unless parent_task_updated.has_sub_task?

    subtasks = parent_task_updated.sub_tasks

    date_parent_task = parent_task_updated.date.to_date

    subtasks.each do |subtask|
      original_time = subtask.date.strftime("%H:%M")

      subtask.update(date: "#{date_parent_task} #{original_time}")
    end
  end

  def date_parent_task_changed?(before_updated:)
    new_task_date = @task_params[:date].to_date
    @old_task_date != new_task_date
  end
end