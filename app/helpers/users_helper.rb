module UsersHelper
  def friendable?(user)
    !user_is_current_user?(user) && !current_user.pending_friends.include?(user)
  end

  def new_friendship_eligible?(user)
    current_user != user &&
    !current_user.pending_friends.include?(user) && 
      !current_user.friends.include?(user)
  end
end
