class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @sender = current_user
    @receiver = User.find(params[:receiver_id])
    @friendship = @sender.sent_pending_requests.build(receiver: @receiver)
    if @friendship.save
      send_notification(@sender, @receiver)
      flash[:success] = "Friend request sent to #{@receiver.first_name}"
    else
      flash[:warning] = 'Failed to send friend request. Please try again'
    end
    redirect_to root_url
  end

  def update
    @friendship = Friendship.where(sender_id: params[:friendship][:sender_id], receiver_id: current_user.id).first
    if @friendship.update(friendship_params)
      flash[:info] = 'Friendship accepted!'
    else
      flash[:warning] = 'Failed to accept friendship'
    end
    redirect_to notifications_path
  end

  private

  def friendship_params
    params.require(:friendship).permit(:sender_id, :receiver_id, :status)
  end

  def send_notification(sender, receiver)
    sender.sent_notifications.create(receiver: receiver,
                                     object_type: 'Friendship',
                                     description: 'friend request')
  end
end
