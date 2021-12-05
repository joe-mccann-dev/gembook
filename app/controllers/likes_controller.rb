class LikesController < ApplicationController
  include NotificationsManager

  before_action :authenticate_user!
  before_action :set_liked_post, only: [:create]
  after_action -> { send_like_notification(@liked_post.user.id) },
               only: [:create]

  def create
    @liked_post = Post.find(params[:post_id])
    @like = current_user.likes.build(post: @liked_post)
    if @like.save
      flash[:info] = "You liked #{@liked_post.user.first_name}'s post"
    else
      flash[:warning] = 'Failed to like post'
    end
    redirect_to root_url
  end

  private

  def send_like_notification(user_id)
    send_notification({ receiver_id: user_id,
                        object_type: 'Like',
                        description: 'liked your post',
                        time_sent: Time.zone.now.to_s })
  end

  def set_liked_post
    @liked_post = Post.find(params[:post_id])
  end
end
