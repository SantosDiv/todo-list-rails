class CreateTask < TasksManager
  def execute
    task = Task.create(@task_params)
    update_parent_status(parent: task.parent) if subtask?
    task
  end

  private

  def update_parent_status(parent:)
    parent.change_parent_status!
  end
end