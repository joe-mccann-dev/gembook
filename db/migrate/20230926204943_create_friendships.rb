class CreateFriendships < ActiveRecord::Migration[7.0]
  def change
    create_table :friendships do |t|
      t.column :status, :integer, default: 0
      t.column :sender_id, :integer
      t.column :receiver_id, :integer

      t.timestamps
    end
    add_index :friendships, :sender_id
    add_index :friendships, :receiver_id
    add_index :friendships, %i[sender_id receiver_id], unique: true
  end
end
