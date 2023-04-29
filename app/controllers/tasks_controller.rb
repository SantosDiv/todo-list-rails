class TasksController < ApplicationController
  before_action :set_task, only: [:update, :destroy]

  def index
    if filter_date_params
      @tasks = Task.filter_by_date(start_date: start_date, end_date: end_date)
      @tasks_presenters = @tasks.map { |task| TaskPresenter.new(task: task) }
      return
    end

    @tasks_today = Task.only_today
    @tasks_tomorrow = Task.only_tomorrow
    @tasks_today_presenters = @tasks_today.map { |task| TaskPresenter.new(task: task) }
    @tasks_tomorrow_presenters = @tasks_tomorrow.map { |task| TaskPresenter.new(task: task) }
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

  def filter_date_params
    nil
  end

  def start_date
    filter_date_params[:date].beginning_of_day
  end

  def end_date
    filter_date_params[:date].end_of_day
  end
end