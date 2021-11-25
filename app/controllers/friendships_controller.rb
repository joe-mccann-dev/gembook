class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
  end

  private

  def friendship_params
    params.require(:friendship).permit(:sender_id, :receiver_id, :status)
  end
end
