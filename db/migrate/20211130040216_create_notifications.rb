class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :sender, index: true
      t.references :receiver, index: true
      t.column :read, :boolean, default: false
      t.column :object_type, :string
      t.column :description, :string

      t.timestamps
    end
  end
end
