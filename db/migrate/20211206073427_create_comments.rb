class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|

      t.references :user, index: true
      t.references :post, index: true
      t.column :content, :text

      t.timestamps
    end
  end
end
