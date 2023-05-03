class TasksManager
  def initialize(task_params:)
    @task_params = task_params
    validate_params!
  end

  def execute
    raise NotImplementedError.new("Method should be implemented in concrete class")
  end

  private

  def validate_params!
    required_params = [{ key: :description, key_translated: "descrição" }]

    validate_datetime_subtask! if subtask?

    validate_date! unless subtask?

    required_params.each do |required_param|
      key = required_param[:key]
      if @task_params[key].nil? || @task_params[key].empty?
        raise TaskException.new(message: "A #{required_param[:key_translated]} é obrigatório(a)")
      end
      true
    end
  end

  def subtask?
    @task_params[:parent_id].present?
  end

  def validate_datetime_subtask!
    return true if @task_params[:date].nil?

    parent_task = Task.find(@task_params[:parent_id])

    if parent_task.date.to_date != @task_params[:date].to_date
      raise TaskException.new(message: 'A data da subtarefa não pode ser diferente da tarefa original.')
    end

    true
  end

  def validate_date!
    valid_min_date = Time.zone.today.to_date
    if @task_params[:date].to_date < valid_min_date
      raise TaskException.new(message: "Data inválida! Por favor insira uma data a partir do dia: #{valid_min_date.strftime("%d/%m/%Y")}")
    end
  end
end