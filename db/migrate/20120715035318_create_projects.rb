class CreateProjects < ActiveRecord::Migration
  def change
    create_table(:projects) do |t|
      t.integer :subscription_id
      t.string :name

      t.timestamps
    end

    add_index :projects, :subscription_id
  end
end
