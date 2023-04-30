class TasksController < ApplicationController
  before_action :set_task, only: [:update, :destroy, :change_status]

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
      @task.transaction do
        @task.save!
        redirect_to tasks_path, success: "Tarefa criada com sucesso"
      end
    rescue
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
      redirect_to tasks_path, success: "Tarefa deletada com sucesso"
    rescue
      redirect_to tasks_path, danger: "Ocorreu um erro ao deletar a tarefa"
    end
  end

  def change_status
    begin
      old_status = @task.done

      @task.update(done: !old_status)
      redirect_to tasks_path
    rescue
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

  def validate_params!
    required_params = [:description, :done]
    required_params.each do |required_param|
      if params[required_param].nil? || params[required_param].empty?
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