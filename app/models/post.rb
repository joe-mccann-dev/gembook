class Post < ApplicationRecord
  belongs_to :user
  has_many :likes
  has_many :likers, through: :likes, source: :user
end
