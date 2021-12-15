module UsersHelper
  def full_name(user)
    "#{user.first_name} #{user.last_name}"
  end

  def friendable?(user)
    !user_is_current_user?(user) || !current_user.pending_friends.include?(user)
  end
end
