class TasksController < ApplicationController
  def index
    @task = Task.new
    @tasks = if params[:filter] == "completed"
      Task.where(completed: true)

    elsif params[:filter] == "incompleted"
      Task.where(completed: false)
    else
      Task.all
    end

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("tasks", partial: "tasks/task", locals: { tasks: @tasks })
      end
    end
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = "Task foi criada com sucesso." }
        format.html { redirect_to tasks_path, notice: "Task foi criada com sucesso." }
      end
    else
      @tasks = Task.all
      render :index
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    @tasks = Task.all

    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "Task foi deletada com sucesso." }
    end
  end

  def delete_completed_tasks
    @tasks = Task.where(completed: true)
    @tasks.destroy_all

    @tasks = Task.all

    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "Tasks completadas foram deletadas com sucesso." }
    end
  end

  def complete_task
    @task = Task.find(params[:id])
    @task.completed = !@task.completed
    @task.save

    @tasks = Task.all

    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "Task foi marcada como completa." }
      format.html { redirect_to tasks_path, notice: "Task foi marcada como completa." }
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :category_id)
  end
end
