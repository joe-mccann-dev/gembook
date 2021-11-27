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
  # the one requesting the friendship is the 'sender', -> foreign_key is sender_id
  has_many :sent_friend_requests,
           class_name: 'Friendship',
           foreign_key: 'sender_id'
  # the one accepting the friendship is the 'receiver', -> foreign_key is receiver_id
  has_many :received_friend_requests,
           class_name: 'Friendship',
           foreign_key: 'receiver_id'
  # the receivers of a user's friend requests are friends once status is 'accepted'
  has_many :requested_friends,
           through: :sent_friend_requests,
           source: :receiver
  # those who sent a user friend requests are friends once status is 'accepted'
  has_many :received_friends, \
           through: :received_friend_requests,
           source: :sender

  def friends
    requested_friends + received_friends
  end
end
