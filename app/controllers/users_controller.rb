class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def index
    @friendship = current_user.sent_pending_requests.build
    @users = User.where.not(id: [current_user.id, current_user.friends.map(&:id)].flatten)
    @friends = current_user.friends
    @friendships = current_user.friendships_via_friend_id
    @results = User.search(params[:query])
  end

  def show
    @profile = @user.profile
    @post = current_user.posts.build
    @posts = @user.posts.with_attached_image
                        .includes([:image_attachment, :comments, :likes, :likers])
                        .order(created_at: :desc)
    @friendship = current_user.requests_via_sender_id[@user.id]
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
