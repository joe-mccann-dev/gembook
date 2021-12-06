module NotificationsManager
  private

  def send_notification(args = {})
    current_user.sent_notifications.create!(receiver_id: args[:receiver_id],
                                            object_type: args[:object_type],
                                            description: args[:description],
                                            time_sent: args[:time_sent],
                                            object_url: args[:object_url])
  end

  def update_notification(object_type, sender_id, time_sent)
    current_user.received_notifications.find_by(object_type: object_type,
                                                sender_id: sender_id,
                                                time_sent: time_sent)
                .update(read: true)
  end
end
