class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github]
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_comments, through: :likes, source: :likeable, source_type: 'Comment'
  has_many :liked_posts, through: :likes, source: :likeable, source_type: 'Post'
  has_one :profile, dependent: :destroy
  has_many :sent_notifications,
           class_name: 'Notification',
           foreign_key: 'sender_id',
           dependent: :destroy
  has_many :received_notifications,
           class_name: 'Notification',
           foreign_key: 'receiver_id',
           dependent: :destroy

  # PENDING FRIEND REQUESTS
  has_many :sent_pending_requests, -> { friendship_pending },
           class_name: 'Friendship',
           foreign_key: 'sender_id',
           dependent: :destroy
  has_many :received_pending_requests, -> { friendship_pending },
           class_name: 'Friendship',
           foreign_key: 'receiver_id',
           dependent: :destroy

  # ACCEPTED FRIEND REQUESTS
  # the one requesting the friendship is the 'sender', -> foreign_key is sender_id
  has_many :sent_accepted_requests, -> { friendship_accepted },
           class_name: 'Friendship',
           foreign_key: 'sender_id',
           dependent: :destroy
  # the one accepting the friendship is the 'receiver', -> foreign_key is receiver_id
  has_many :received_accepted_requests, -> { friendship_accepted },
           class_name: 'Friendship',
           foreign_key: 'receiver_id',
           dependent: :destroy

  # DECLINED FRIEND REQUESTS
  has_many :sent_declined_requests, -> { friendship_declined },
           class_name: 'Friendship',
           foreign_key: 'sender_id',
           dependent: :destroy
  has_many :received_declined_requests, -> { friendship_declined },
           class_name: 'Friendship',
           foreign_key: 'receiver_id',
           dependent: :destroy

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

  validates :first_name, presence: true
  validates :last_name, presence: true

  validates_uniqueness_of :first_name, scope: :last_name, message: "A user with that first and last name already exists."
  validates_uniqueness_of :email
  
  def self.from_omniauth(auth)
    oauth_user = where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.name.split.first
      # A Github user without a name will send github username as 'name'.
      # Set as emtpy string if user.last_name returns nil
      user.last_name = auth.info.name.split.second || ''
      # user.skip_confirmation!
    end
    UserMailer.welcome_email(oauth_user).deliver if oauth_user.new_record? && oauth_user.save
    oauth_user
  end

  def self.search(query)
    return unless query

    name = query.strip.downcase.split
    where('lower(first_name) = ? OR lower(last_name) = ?', name.first, name.last)
    .includes(:profile)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def current_password_required?
    provider.blank?
  end

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

  def notifications
    sent_notifications + received_notifications
  end

  def requests_via_sender_id
    requests = received_pending_requests
    sender_ids = requests.pluck(:sender_id)
    sender_ids.to_h do |id|
      [id, requests.find_by(sender_id: id)]
    end
  end

  def requests_via_notification_sender_id
    notifications = received_notifications
    sender_ids = notifications.pluck(:sender_id)
    sender_ids.to_h do |id|
      [id, Friendship.find_by(sender_id: id, receiver_id: self.id)]
    end
  end

  def friendships_via_friend_id
    friendships_via_sender_id.merge(friendships_via_receiver_id).except(id)
  end

  def find_like(likeable)
    likes.find_by(likeable_id: likeable.id)
  end

  private

  def friendships_via_sender_id
    friendships = accepted_requests
    sender_ids = friendships.pluck(:sender_id)
    sender_ids.to_h do |id|
      [id, friendships.find { |f| f.sender_id == id }]
    end
  end

  def friendships_via_receiver_id
    friendships = accepted_requests
    receiver_ids = friendships.pluck(:receiver_id)
    receiver_ids.to_h do |id|
      [id, friendships.find { |f| f.receiver_id == id }]
    end
  end
end
