class TasksController < ApplicationController
  before_action :set_task, only: [:update, :destroy, :change_status]

  def index
    @tasks_today = Task.only_today
    @tasks_tomorrow = Task.only_tomorrow
    @tasks_today_presenters = @tasks_today.map { |task| TaskPresenter.new(task: task) }
    @tasks_tomorrow_presenters = @tasks_tomorrow.map { |task| TaskPresenter.new(task: task) }
  end

  def new
    @parent_id = parent_id
  end

  def create
    begin
      uc = CreateTask.new(task_params: task_params)
      uc.execute

      redirect_to tasks_path, success: "Tarefa criada com sucesso"
    rescue CreateTaskException => exception
      redirect_to get_redirect_path, danger: exception.message
    rescue => exception
      redirect_to new_task_path, danger: @task.errors.full_messages.to_sentence
    end
  end

  def update
    begin
      validate_params!

      @task.update(task_params)
      redirect_to tasks_path, success: "Tarefa atualizada com sucesso"
    rescue
      redirect_to tasks_path, danger: "Ocorreu um erro ao atualizar a tarefa"
    end
  end

  def destroy
    begin
      @task.destroy!

      if @task.sub_task?
        change_parent_status(parent: @task.parent)
      end

      redirect_to tasks_path, success: "Tarefa deletada com sucesso"
    rescue
      redirect_to tasks_path, danger: "Ocorreu um erro ao deletar a tarefa"
    end
  end

  def change_status
    begin
      old_status = @task.done

      @task.update(done: !old_status)

      if @task.sub_task?
        change_parent_status(parent: @task.parent)
      end

      redirect_to tasks_path
    rescue => exception
      redirect_to tasks_path, danger: "Ocorreu um erro ao mudar o status da tarefa"
    end
  end

  private

  def set_task
    begin
      @task = Task.find(params[:id] || params[:task_id])
    rescue ActiveRecord::RecordNotFound => exception
      redirect_to tasks_path, alert: "Não encontramos nenhuma tarefa com este id. Tente novamente"
    end
  end

  def task_params
    params.permit(:description, :date, :done, :parent_id)
  end

  def parent_id
    params[:parent_id]
  end

  def validate_params!
    required_params = [:description, :done]
    required_params.each do |required_param|
      if params[required_param].nil? || params[required_param].empty?
        raise "O parâmetro #{required_param} é obrigatório"
      end
      true
    end
  end

  def change_parent_status(parent:)
    parent.change_parent_status!
  end

  def get_redirect_path
    return new_task_path(parent_id: parent_id) if parent_id.present?
    new_task_path
  end

end