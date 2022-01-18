module NotificationsManager
  private

  def send_notification(args = {})
    current_user.sent_notifications.create(args)
  end

  def update_notification(args = {})
    current_user.received_notifications.find_by(object_type: args[:object_type],
                                                sender_id: args[:sender_id])
                .update(read: true)
  end
end
