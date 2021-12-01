class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  include NotificationsManager

  def create
    receiver = User.find(params[:receiver_id])
    @friendship = current_user.sent_pending_requests.build(receiver: receiver)
    @notification =
      if @friendship.save
        # notify receiver current_user sent them a friend request
        send_friend_request_notification(receiver.id, 'new friend request')
        flash[:success] = "Friend request sent to #{receiver.first_name}"
      else
        flash[:warning] = 'Failed to send friend request. Please try again'
      end
    redirect_to root_url
  end

  def update
    sender_id = params[:friendship][:sender_id]
    @friendship = Friendship.find_by(sender_id: sender_id, receiver_id: current_user.id)
    if @friendship.update(friendship_params)
      update_notification('Friendship', sender_id, params[:notification][:time_sent])
      if @friendship.accepted?
        flash[:info] = 'Friendship accepted!'
        # notify sender that receiver has accepted the request
        send_friend_request_notification(sender_id, 'accepted your friend request')
      else
        flash[:info] = 'Friendship declined.'
      end
    else
      flash[:warning] = 'Failed to accept friendship'
    end
    redirect_to notifications_path
  end

  private

  def friendship_params
    params.require(:friendship).permit(:sender_id, :receiver_id, :status)
  end

  def send_friend_request_notification(user_id, description)
    send_notification({ sender_id: current_user.id,
                        receiver_id: user_id,
                        object_type: 'Friendship',
                        description: description,
                        time_sent: Time.zone.now.to_s })
  end
end
