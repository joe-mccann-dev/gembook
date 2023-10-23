module NotificationsHelper

  def show_notification(notification, friendship)
    case notification.object_type
    when 'Friendship'
      render partial: 'friendship_notification', locals: { notification: notification, friendship: friendship  }
    else
      render partial: 'standard_notification', locals: { notification: notification }
    end
  end
end
