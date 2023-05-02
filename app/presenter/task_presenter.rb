class TaskPresenter
  def initialize(task:)
    @task = task
  end

  def description
    @task.description
  end

  def task_id
    @task.id
  end

  def parent_id
    @task.parent_id
  end

  def parent?
    @task.parent?
  end

  def done?
    @task.done
  end

  def status_translated
    return "Concluída" if self.done?
    return "Pendente"
  end

  def status_class_badge
    return "done-badge" if self.done?
    return "pending-badge"
  end

  def status_class_icon
    return "done-icon" if self.done?
    return "text-secondary"
  end

  def description_class
    class_css = ""
    class_css << "line-through text-secondary" if @task.done?

    return class_css << " fw-light fs-6" if @task.sub_task?
    class_css << " fw-normal"
  end

  def has_sub_task?
    @task.has_sub_task?
  end

  def sub_tasks
    @task.sub_tasks.map { |sub_task| TaskPresenter.new(task: sub_task) }
  end

end