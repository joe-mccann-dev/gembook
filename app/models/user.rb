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
  has_many :sent_notifications,
           class_name: 'Notification',
           foreign_key: 'sender_id'
  has_many :received_notifications,
           class_name: 'Notification',
           foreign_key: 'receiver_id'

  # PENDING FRIEND REQUESTS
  has_many :sent_pending_requests, -> { friendship_pending },
           class_name: 'Friendship',
           foreign_key: 'sender_id'
  has_many :received_pending_requests, -> { friendship_pending },
           class_name: 'Friendship',
           foreign_key: 'receiver_id'

  # ACCEPTED FRIEND REQUESTS
  # the one requesting the friendship is the 'sender', -> foreign_key is sender_id
  has_many :sent_accepted_requests, -> { friendship_accepted },
           class_name: 'Friendship',
           foreign_key: 'sender_id'
  # the one accepting the friendship is the 'receiver', -> foreign_key is receiver_id
  has_many :received_accepted_requests, -> { friendship_accepted },
           class_name: 'Friendship',
           foreign_key: 'receiver_id'

  # DECLINED FRIEND REQUESTS
  has_many :sent_declined_requests, -> { friendship_declined },
           class_name: 'Friendship',
           foreign_key: 'sender_id'
  has_many :received_declined_requests, -> { friendship_declined },
           class_name: 'Friendship',
           foreign_key: 'receiver_id'

  # FRIENDS
  has_many :pending_requested_friends,
           through: :sent_pending_requests,
           source: :receiver

  has_many :pending_received_friends,
           through: :received_pending_requests,
           source: :sender
  # the receivers of a user's friend requests are friends once status is 'accepted'
  has_many :accepted_requested_friends,
           through: :sent_accepted_requests,
           source: :receiver
  # those who sent a user friend requests are friends once status is 'accepted'
  has_many :accepted_received_friends,
           through: :received_accepted_requests,
           source: :sender

  def friends
    accepted_requested_friends + accepted_received_friends
  end

  def pending_friends
    pending_requested_friends + pending_received_friends
  end

  def pending_requests
    sent_pending_requests + received_pending_requests
  end

  def accepted_requests
    sent_accepted_requests + received_accepted_requests
  end

  def declined_requests
    sent_declined_requests + received_declined_requests
  end

  def friend_requests
    pending_requests + accepted_requests + declined_requests
  end

  protected

  def mark_notification_as_read(params = {})
    received_notifications.find_by(object_type: params[:object_type],
                                   sender_id: params[:sender_id])
                          .update(read: true)
  end
end
