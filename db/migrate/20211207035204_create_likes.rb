class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.references :likeable, polymorphic: true
      t.references :user, index: true

      t.timestamps
    end
    add_index :likes, %i[user_id likeable_type likeable_id], unique: true
  end
end
