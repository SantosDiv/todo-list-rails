class TasksController < ApplicationController
  before_action :set_task, only: [:update, :destroy]

  def index
    @tasks = Task.only_parent.order(:date, :asc)
  end

  def new
  end

  def create
    @task = Task.new(task_params)
    begin
      @task.save!
      redirect_to tasks_path, notice: "Tarefa criada com sucesso", status: :created
    rescue => exception
      redirect_to new_task_path, alert: exception.message, status: :bad_request
    end
  end

  def update
    begin
      @task.update(task_params)
      redirect_to tasks_path, notice: "Tarefa atualizada com sucesso", status: :updated
    rescue => exception
      redirect_to tasks_path, alert: "Ocorre um erro ao atualizar a tarefa", status: :bad_request
    end
  end

  def destroy
    if @task.destroy!
      redirect_to tasks_path, notice: "Tarefa deletada com sucesso", status: :ok
    else
      render :index, alert: "Ocorre um erro ao deletar a tarefa", status: :bad_request
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:description, :date, :done)
  end
end