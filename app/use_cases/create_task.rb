class CreateTask
  def initialize(task_params:)
    @task_params = task_params
    validate_params!
  end

  def execute
    validate_datetime_subtask! if subtask?

    task = Task.create(@task_params)
    update_parent_status(parent: task.parent) if subtask?
    task
  end

  private

  def validate_params!
    required_params = [{ key: :description, key_translated: "descrição" }]
    required_params.each do |required_param|
      key = required_param[:key]
      if @task_params[key].nil? || @task_params[key].empty?
        raise CreateTaskException.new(message: "A #{required_param[:key_translated]} é obrigatório(a)")
      end
      true
    end
  end

  def subtask?
    @task_params[:parent_id].present?
  end

  def update_parent_status(parent:)
    parent.change_parent_status!
  end

  def validate_datetime_subtask!
    parent_task = Task.find(@task_params[:parent_id])
    raise CreateTaskException.new if parent_task.date.to_date != @task_params[:date].to_date
    true
  end
end