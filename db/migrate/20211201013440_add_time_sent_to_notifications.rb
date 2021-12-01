class AddTimeSentToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :time_sent, :string
  end
end
