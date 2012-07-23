class ProjectImagesController < ApplicationController
  before_filter :authenticate_subscriber!
  before_filter :find_models

  def new
    @project_image = @project.project_images.new
  end

  def create
    @project_image = @project.project_images.new(params[:project_image])

    if @project_image.save
      flash[:notice] = "Successfully added new project image."
      redirect_to projects_url
    else
      flash[:alert] = @project_image.errors.full_messages
      render :new
    end
  end

  protected

  def find_models
    @project = Project.find(params[:project_id])
  end
end