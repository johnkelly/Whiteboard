class CreateProjects < ActiveRecord::Migration
  def change
    create_table(:projects) do |t|
      t.integer :subscription_id
      t.string :name
    end

    add_index :projects, :subscription_id
  end
end
