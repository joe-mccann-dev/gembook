class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.received_notifications.includes(%i[sender receiver])
  end

  private

  def notification_params
    params.require(:notification).permit(:read)
  end
end
