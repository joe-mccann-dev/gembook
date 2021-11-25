class AddUserIdToFriendships < ActiveRecord::Migration[6.1]
  def change
    add_column :friendships, :user_id, :integer
  end
end
