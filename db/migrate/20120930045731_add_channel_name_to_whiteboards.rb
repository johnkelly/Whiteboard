class AddChannelNameToWhiteboards < ActiveRecord::Migration
  def change
    add_column :drawings, :channel_name, :string
  end
end
