module NotificationsManager
  private

  def send_notification(args = {})
    current_user.sent_notifications.create!(receiver_id: args[:receiver_id],
                                            object_type: args[:object_type],
                                            description: args[:description],
                                            time_sent: args[:time_sent],
                                            object_url: args[:object_url])
  end

  def update_notification(args = {})
    current_user.received_notifications.find_by(object_type: args[:object_type],
                                                sender_id: args[:sender_id])
                .update(read: true)
  end
end
