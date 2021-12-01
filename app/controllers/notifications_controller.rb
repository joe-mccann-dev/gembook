class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.received_notifications.includes(%i[sender receiver])
  end

  def update
    @notification = Notification.find(params[:notification][:notification_id])
    if @notification.update(notification_params)
      flash[:info] = "Notification dismissed"
    else
      flash[:warning] = "Failed to dismiss notification"
    end
    redirect_to notifications_path
  end

  private

  def notification_params
    params.require(:notification).permit(:read)
  end
end
