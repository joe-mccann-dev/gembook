class FriendshipsController < ApplicationController
  include NotificationsManager

  before_action :authenticate_user!
  before_action :set_receiver, only: [:create]
  before_action :set_update_params, only: [:update]
  after_action -> { send_friend_request_notification(@receiver.id, 'new friend request') },
               only: [:create]
  after_action -> { send_friend_request_notification(@sender_id, 'accepted your friend request') },
               only: [:update],
               if: proc { @friendship.accepted? }
  after_action -> { mark_notification_read('Friendship', @sender_id, @time_sent) }, only: [:update]

  def create
    @friendship = current_user.sent_pending_requests.build(receiver: @receiver)
    if @friendship.save
      flash[:success] = "Friend request sent to #{@receiver.first_name}"
    else
      flash[:warning] = 'Failed to send friend request. Please try again'
    end
    redirect_to request.referrer
  end

  def update
    if @friendship.update(friendship_params)
      flash[:info] = if @friendship.accepted?
                       'Friendship accepted!'
                     else
                       'Friendship declined.'
                     end
    else
      flash[:warning] = 'Failed to accept or decline friendship'
    end
    redirect_to request.referrer
  end

  private

  def friendship_params
    params.require(:friendship).permit(:sender_id, :receiver_id, :status)
  end

  def set_receiver
    @receiver = User.find(params[:receiver_id])
  end

  def set_update_params
    @sender_id = params[:friendship][:sender_id]
    @time_sent = params[:notification][:time_sent]
    @friendship = Friendship.find_by(sender_id: @sender_id, receiver_id: current_user.id)
  end

  def mark_notification_read(object_type, sender_id, time_sent)
    update_notification(object_type, sender_id, time_sent)
  end

  # TODO make object_url more relevant to friendship
  def send_friend_request_notification(user_id, description)
    send_notification({ receiver_id: user_id,
                        object_type: 'Friendship',
                        description: description,
                        time_sent: Time.zone.now.to_s,
                        object_url: users_path })
  end
end
