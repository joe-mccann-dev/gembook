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
      flash[:info] = "You liked #{@liked_object.user.first_name}'s #{object_to_s(@liked_object)}"
    else
      flash[:warning] = 'Failed to like post'
    end
    redirect_to root_url
  end

  private

  def send_like_notification(liked_object)
    return if liked_object.user == current_user

    send_notification({ receiver_id: liked_object.user.id,
                        object_type: 'Like',
                        description: "liked your #{object_to_s(liked_object)}",
                        time_sent: Time.zone.now.to_s,
                        object_url: determine_path(liked_object) })
  end

  # TODO update to handle other likeable objects
  def set_liked_object
    @liked_object = if params[:post_id].present?
                      Post.find(params[:post_id])
                    else
                      Comment.find(params[:comment_id])
                    end
  end

  def determine_path(liked_object)
    likeables = {
      'Post' => post_path(liked_object),
      'Comment' => comment_path(liked_object)
    }
    likeables[liked_object.class.to_s]
  end

  def object_to_s(object)
    object.class.to_s.downcase
  end
end
