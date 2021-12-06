class AddObjectUrlToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :object_url, :string
  end
end
