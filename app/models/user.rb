class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts
  has_many :comments
  has_many :likes
  has_many :liked_posts, through: :likes, source: :posts
  has_one :profile
  has_many :friendships
  has_many :friends, -> { where(friendship: { status: 'accepted' }) }, through: :friendships, class_name: 'User'
  has_many :friend_requests, -> { where(friendship: { status: 'pending' }) }, through: :friendships
  has_many :friend_requests, -> { where(friendship: { status: 'denied' }) }, through: :friendships
end
