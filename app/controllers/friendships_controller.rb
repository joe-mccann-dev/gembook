class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @sender = current_user
    @receiver = User.find(params[:receiver_id])
    @friendship = @sender.sent_pending_requests.build(sender: @sender, receiver: @receiver)
    if @friendship.save
      flash[:success] = "Friend request sent to #{@receiver.first_name}"
      redirect_to root_url
    end
  end

  private

  def friendship_params
    params.require(:friendship).permit(:sender_id, :receiver_id, :status)
  end
end
