class Comment < ApplicationRecord
  default_scope { includes([:user, :comments]) }
  belongs_to :user

  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable

  has_many :likes, as: :likeable
  has_many :likers, through: :likes, source: :user
end
