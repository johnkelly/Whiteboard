class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table(:subscribers) do |t|
      t.timestamps
    end

    add_index :subscribers, :subscription_id

    add_column :users, :subscriber_id, :integer
    add_column :subscriptions, :subscriber_id, :integer

    add_index :users, :subscriber_id
    add_index :subscriptions, :subscriber_id
  end
end
