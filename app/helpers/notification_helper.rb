module NotificationHelper

  def show_notification(notification)
    case notification.object_type
    when 'Friendship'
      render partial: 'friendship_notification', locals: { notification: notification }
    else
      render partial: 'standard_notification', locals: { notification: notification }
    end
  end
end
