class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :user, index: true, unique: true
      t.column :content, :text
      t.timestamps
    end
  end
end
