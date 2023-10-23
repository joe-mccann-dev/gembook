class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :sender, index: true
      t.references :receiver, index: true
      t.column :read, :boolean, default: false
      t.column :object_type, :string
      t.column :description, :string
      t.column :time_sent, :string

      t.timestamps
    end
  end
end
