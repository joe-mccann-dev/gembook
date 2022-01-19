module NotificationsManager
  private

  def send_notification(args = {})
    current_user.sent_notifications.create(args)
  end

  def update_notification(args = {})
    # in the case of a user "unfriending" and then "refriending", there will be two notifications,
    # thus, the need for `where` instead of `find_by`.
    notifications = current_user.received_notifications.where(object_type: args[:object_type],
                                                              sender_id: args[:sender_id])
    notifications.each { |n| n.update(read: true) }
    notifications
  end
end
