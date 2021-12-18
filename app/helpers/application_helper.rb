module ApplicationHelper

  private
  
  def object_to_s(object)
    object.class.to_s.downcase
  end

  def user_is_current_user?(user)
    user == current_user
  end

  def display_notifications(user)
    count = user.received_notifications.unread.count
    count == 1 ? "#{count} unread notification" : "#{count} unread notifications"
  end
end
