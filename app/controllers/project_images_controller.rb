class ProjectImagesController < ApplicationController
  before_filter :authenticate_subscriber!
  before_filter :find_models

  def new
    @project_image = @project.project_images.new
  end

  def create
    @project_image = @project.project_images.new
    image_data = params[:image_data]
    image_data.gsub!("data:image/png;base64,", "")

    temp_file_name = "image_project_#{@project.id}_#{Time.now.to_i}.png"
    file = File.new(Rails.root.join("tmp", temp_file_name), 'wb')
    file.write(Base64.decode64(image_data))

    @project_image.canvas = file
    @project_image.save!

    respond_to do |format|
      format.js
    end
  end

  def show
    @project_image = @project.project_images.find(params[:id])
  end

  protected

  def find_models
    @project = Project.find(params[:project_id])
  end
end