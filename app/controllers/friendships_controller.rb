class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    sender = current_user
    receiver = User.find(params[:receiver_id])
    @friendship = sender.sent_pending_requests.build(receiver: receiver)
    if @friendship.save
      send_notification({ sender: sender,
                          receiver: receiver,
                          object_type: 'Friendship',
                          description: 'friend request' })
      flash[:success] = "Friend request sent to #{receiver.first_name}"
    else
      flash[:warning] = 'Failed to send friend request. Please try again'
    end
    redirect_to root_url
  end

  def update
    @friendship = Friendship.find_by(sender_id: params[:friendship][:sender_id], receiver_id: current_user.id)
    if @friendship.update(friendship_params)
      update_notification('Friendship', params[:friendship][:sender_id])
      flash[:info] = if @friendship.accepted?
                       'Friendship accepted!'
                     else
                       'Friendship declined.'
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

  def update_notification(object_type, sender_id)
    mark_notification_as_read({ object_type: object_type, sender_id: sender_id })
  end
end
