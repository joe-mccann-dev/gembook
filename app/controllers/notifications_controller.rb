class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_friendships, only: [:index, :update]

  def index
    @notifications = current_user.received_notifications.includes([:sender]).order(created_at: :desc)
  end

  def update
    @notification = Notification.find(params[:id])
    if @notification.update(notification_params)
      respond_to do |format|
        format.turbo_stream {}
        format.html {
          flash[:info] = 'Notification dismissed'
          redirect_to notifications_path
        }
      end
    else
      flash[:warning] = 'Failed to dismiss notification'
      redirect_to notifications_path
    end
  end

  def dismiss_all
    current_user.received_notifications.includes(:sender, :receiver).map { |n| n.update(read: true) }
    flash[:info] = 'Dismissed all notifications'
    redirect_to notifications_path
  end

  private

  def notification_params
    params.require(:notification).permit(:read)
  end

  def set_friendships
    @friendships = current_user.requests_via_notification_sender_id
  end
end
