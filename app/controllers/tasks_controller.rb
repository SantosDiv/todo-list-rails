class TasksController < ApplicationController
  before_action :set_task, only: [:edit, :update, :destroy, :change_status]

  def index
    @show_tasks_days = get_tasks_by_filter_date || get_standard_day_tasks
  end

  def new
    @parent_id = parent_id
  end

  def edit
    @parent_id = parent_id
    @time_value = @task.date.strftime("%Y-%m-%dT%k:%M")
  end

  def create
    begin
      uc = CreateTask.new(task_params: task_params)
      uc.execute

      redirect_to tasks_path, success: "Tarefa criada com sucesso"
    rescue TaskException => exception
      redirect_to get_redirect_path(action: :new), danger: exception.message
    rescue
      redirect_to new_task_path, danger: "Ocorreu um erro inesperado."
    end
  end

  def update
    begin
      uc = UpdateTask.new(task_params: task_params)
      uc.execute(task_model: @task)

      redirect_to tasks_path, success: "Tarefa atualizada com sucesso"
    rescue TaskException => exception
      redirect_to get_redirect_path(action: :edit), danger: exception.message
    rescue => exception
      redirect_to tasks_path, danger: "Ocorreu um erro inesperado."
    end
  end

  def destroy
    begin
      if @task.sub_task?
        change_parent_status(parent: @task.parent)
      end

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

      @task.change_all_subtasks_status_by_parent! if @task.parent?

      change_parent_status(parent: @task.parent) if @task.sub_task?

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

  def change_parent_status(parent:)
    parent.change_parent_status!
  end

  def get_redirect_path(action:)
    if action == :edit
      return edit_task_path(parent_id: parent_id) if parent_id.present?
      return edit_task_path
    end

    return new_task_path(parent_id: parent_id) if parent_id.present?
    new_task_path
  end

  def get_standard_day_tasks
    [
      {
        label_day: "Hoje",
        tasks_presenters: get_all_tasks_by_date(date: today)
      },
      {
        label_day: "Amanhã",
        tasks_presenters:  get_all_tasks_by_date(date: tomorrow)
      }
    ]
  end

  def get_tasks_by_filter_date
    return if params[:filter_date].nil?

    [
      {
        label_day: params[:filter_date].to_date.strftime("%d/%m/%Y"),
        tasks_presenters: get_all_tasks_by_date(date: params[:filter_date])
      }
    ]
  end

  def get_all_tasks_by_date(date:)
    tasks = Task.filter_by(date: date.to_date)

    tasks.map { |task| TaskPresenter.new(task: task) }
  end

  def today
    Time.zone.today
  end

  def tomorrow
    Time.zone.tomorrow
  end

end