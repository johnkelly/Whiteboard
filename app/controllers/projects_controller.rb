class ProjectsController < ApplicationController
  before_filter :authenticate_subscriber!
  before_filter :find_models

  def index
    @projects = @subscription.projects.includes(:project_images)
  end

  def new
    @project = @subscription.projects.new
  end

  def create
    @project = @subscription.projects.new(params[:project])

    if @project.save
      flash[:notice] = "Sucessfully added new project."
      redirect_to projects_url
    else
      flash[:alert] = @project.errors.full_messages
      render :new
    end
  end

  def destroy
    @project = @subscription.projects.find(params[:id])
    @project.destroy
    flash[:notice] = "Successfully deleted project."
    redirect_to projects_url
  end

  private

  def find_models
    @subscription = current_user.subscription
  end
end