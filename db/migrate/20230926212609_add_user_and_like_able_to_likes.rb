class AddUserAndLikeAbleToLikes < ActiveRecord::Migration[7.0]
  def change
    add_reference :likes, :likeable, polymorphic: true
    add_reference :likes, :user, index: true

    # Add a unique index
    add_index :likes, %i[user_id likeable_type likeable_id], unique: true
  end
end
