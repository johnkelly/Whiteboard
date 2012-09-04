class RemoveProjectandProjectImage < ActiveRecord::Migration
  def up
    drop_table :projects
    drop_table :project_images
  end

  def down
    create_table :projects
    create_table :project_images
  end
end
