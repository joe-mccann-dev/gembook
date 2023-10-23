class AddObjectUrlToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :object_url, :string
  end
end
