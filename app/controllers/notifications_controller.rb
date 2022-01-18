class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.received_notifications.includes([:sender])
    @friendships = current_user.requests_via_notification_sender_id
  end

  def update
    @notification = Notification.find(params[:id])
    if @notification.update(notification_params)
      flash[:info] = 'Notification dismissed'
    else
      flash[:warning] = 'Failed to dismiss notification'
    end
    redirect_to notifications_path
  end

  private

  def notification_params
    params.require(:notification).permit(:read)
  end
end
