class Comment < ApplicationRecord
  belongs_to :user

  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :replies, class_name: "Comment", foreign_key: :parent_comment_id, dependent: :destroy

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  validates :content, presence: true
  validates :content, length: { in: 2..10**4 }

  def edited?
    created_at != updated_at
  end
end
