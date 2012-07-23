class ProjectImage < ActiveRecord::Base
  belongs_to :project

  mount_uploader :canvas, CanvasUploader

  validates_presence_of :project_id
  validates_presence_of :canvas

  attr_accessible :canvas, :canvas_cache

end