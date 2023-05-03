class CreateTask < TasksManager
  def execute
    set_parent_date_in_params if subtask?

    task = Task.create(@task_params)
    update_parent_status(parent: task.parent) if subtask?
    task
  end

  private

  def set_parent_date_in_params
    parent_task = Task.find_by(id: @task_params[:parent_id])
    @task_params[:date] = parent_task.date
  end

  def update_parent_status(parent:)
    parent.change_parent_status!
  end
end