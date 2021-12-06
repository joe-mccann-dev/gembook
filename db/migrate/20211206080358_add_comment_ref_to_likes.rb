class AddCommentRefToLikes < ActiveRecord::Migration[6.1]
  def change
    add_reference :likes, :comment, null: false, foreign_key: true, index: true
    add_index :likes, %i[user_id comment_id], unique: true
  end
end
