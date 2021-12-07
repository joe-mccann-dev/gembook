class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.references :commentable, polymorphic: true
      t.column :content, :text, null: false

      t.timestamps
    end
  end
end
