class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def index
    @friendship = current_user.sent_pending_requests.build
    @users = User.all
    @friends = current_user.friends
    @friendships = current_user.friendships_via_friend_id
  end

  def show
    @profile = @user.profile
    @post = Post.new
    @posts = @user.posts.includes([:comments, :likes]).order(created_at: :desc)
    return unless current_user.pending_received_friends.any?

    @notification = Notification.find_by(sender_id: @user.id, 
                                         receiver_id: current_user.id,
                                         object_type: 'Friendship')
  end

  private

  def set_user
    # return current_user if user navigates to /profile
    @user = if params[:id].present?
              User.find(params[:id])
            else
              current_user
            end
  end
end
