class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # has_many :posts
  # has_many :comments
  # has_many :likes
  # has_many :liked_posts, through: :likes, source: :posts
  # has_one :profile

  # friendship associations
  # requests
  # has_many :pending_sent_friend_requests, -> { where(friendship: { status: 'pending' }) },
  #          through: :friendships,
  #          class_name: 'Friendship',
  #          foreign_key: 'sender_id',
  #          source: :sender

  # has_many :pending_received_friend_requests, -> { where(friendship: { status: 'pending' }) },
  #          through: :friendships,
  #          class_name: 'Friendship',
  #          foreign_key: 'receiver_id',
  #          source: :receiver
  # accepted friendships
  has_many :friendships
  has_many :requested_friends, -> { Friendship.where(status: 'accepted') },
           through: :friendships,
           source: :receiver,
           foreign_key: 'receiver_id'
  has_many :accepted_friends, -> { Friendship.where(status: 'accepted')  },
           through: :friendships,
           source: :sender,
           foreign_key: 'sender_id'
end
