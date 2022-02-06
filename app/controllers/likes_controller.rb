class LikesController < ApplicationController
  include NotificationsManager

  before_action :authenticate_user!
  before_action :set_liked_object, only: [:create, :destroy]
  before_action :set_likeable_id, only: [:create, :destroy]
  after_action -> { send_like_notification(@liked_object) },
               only: [:create]

  def create
    @like = @liked_object.likes.build(user: current_user)
    @like.save
    flash[:success] = "Liked #{object_to_s(@liked_object)} successfully."
    redirect_to "#{request.referrer}#{@likeable_id}" || root_url
  end

  def destroy
    @like = Like.find(params[:id])
    @like.destroy
    flash[:success] = "Unliked #{object_to_s(@liked_object)} successfully."
    redirect_to "#{request.referrer}#{@likeable_id}" || root_url
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

  def set_likeable_id
    @likeable_id = "#likeable-#{object_to_s(@liked_object)}-#{@liked_object.id}"
  end
end
