class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.references :user, index: true
      t.column :nickname, :string
      t.column :bio, :string
      t.column :current_city, :string
      t.column :hometown, :string

      t.timestamps
    end
  end
end
