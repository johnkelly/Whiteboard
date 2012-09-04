class CreateDrawings < ActiveRecord::Migration
  def change
    create_table(:drawings) do |t|
      t.integer :subscription_id
      t.string :canvas

      t.timestamps
    end

    add_index :drawings, :subscription_id
  end
end
