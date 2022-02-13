class Comment < ApplicationRecord
  belongs_to :user

  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  validates :content, presence: true

  def edited?
    created_at != updated_at
  end
end
