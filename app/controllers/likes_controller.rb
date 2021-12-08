class LikesController < ApplicationController
  include NotificationsManager

  before_action :authenticate_user!
  before_action :set_liked_object, only: [:create]
  after_action -> { send_like_notification(@liked_object) },
               only: [:create]

  def create
    # @like = current_user.likes.build(post: @liked_object)
    @like = @liked_object.likes.build(user: current_user)
    if @like.save
      flash[:info] = "You liked #{@liked_object.user.first_name}'s #{@liked_object.class.to_s.downcase}"
    else
      flash[:warning] = 'Failed to like post'
    end
    redirect_to root_url
  end

  private

  def send_like_notification(post)
    return if post.user == current_user

    send_notification({ receiver_id: post.user.id,
                        object_type: 'Like',
                        description: 'liked your post',
                        time_sent: Time.zone.now.to_s,
                        object_url: post_path(post) })
  end

  # TODO update to handle other likeable objects
  def set_liked_object
    @liked_object = if params[:post_id].present?
                      Post.find(params[:post_id])
                    else
                      Comment.find(params[:comment_id])
                    end
  end
end
