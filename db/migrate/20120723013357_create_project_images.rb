class CreateProjectImages < ActiveRecord::Migration
  def change
    create_table(:project_images) do |t|
      t.integer :project_id
      t.string :canvas
    end

    add_index :project_images, :project_id
  end
end
