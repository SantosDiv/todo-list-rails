class TasksController < ApplicationController
  before_action :set_task, only: [:update, :destroy]

  def index
    @tasks = Task.only_parent.order(:date, :asc)
  end

  def new
  end

  def create
    begin
      @task = Task.new(task_params)
      @task.save!
      redirect_to tasks_path, notice: "Tarefa criada com sucesso", status: :created
    rescue => exception
      redirect_to new_task_path, alert: exception.message, status: :bad_request
    end
  end

  def update
    begin
      validate_params!

      @task.update(task_params)
      redirect_to tasks_path, notice: "Tarefa atualizada com sucesso", status: :ok
    rescue => exception
      redirect_to tasks_path, alert: "Ocorre um erro ao atualizar a tarefa", status: :bad_request
    end
  end

  def destroy
    begin
      @task.destroy!
      redirect_to tasks_path, notice: "Tarefa deletada com sucesso", status: :ok
    rescue => exception
      redirect_to tasks_path, alert: "Ocorreus um erro ao deletar a tarefa", status: :bad_request
    end
  end

  private

  def set_task
    begin
      @task = Task.find(params[:id])
    rescue ActiveRecord::RecordNotFound => exception
      redirect_to tasks_path, alert: "Não encontramos essa a tarefa com o id passado. Tente novamente", status: :bad_request
    end
  end

  def task_params
    params.require(:task).permit(:description, :date, :done, :parent_id)
  end

  def validate_params!
    required_params = [:description, :done]

    required_params.each do |required_param|
      if params.dig(:task, required_param).nil? || params.dig(:task, required_param).empty?
        raise "O parâmetro #{required_param} é obrigatório"
      end
      true
    end
  end
end