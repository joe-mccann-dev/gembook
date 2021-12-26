class CommentsController < ApplicationController
  include NotificationsManager

  before_action :set_commented_object, only: [:create]
  before_action :set_comment, only: [:show]
  before_action :set_comment, except: [:new, :create]
  before_action -> { verify_object_viewable(@comment) }, only: [:show]
  # before_action :check_comment_ownership, except: [:show]
  after_action -> { send_comment_notification(@commented_object) },
               only: [:create]

  def create
    @comment = @commented_object.comments.build(comment_params.merge(user: current_user))
    if @comment.save
      flash[:info] = "Successfully created comment"
    else
      flash[:warning] = "Failed to create comment"
    end
    # redirect_to "/##{@commented_object.class.to_s.downcase}-#{@commented_object.id}"
    redirect_to request.referrer
  end

  def show; end

  def edit; end

  def update
    commentable = @comment.commentable
    if @comment.update(comment_params)
      flash[:info] = 'Comment successfully edited.'
      redirect_to public_send("#{object_to_s(commentable)}_path", commentable)
    else
      render :edit
      flash[:warning] = 'Failed to update comment.'
    end
  end

  def destroy
    commentable = @comment.commentable
    if @comment.destroy
      flash[:info] = 'Comment successfully removed.'
    else
      flash[:warning] = "Failed to remove comment."
    end
    redirect_to public_send("#{object_to_s(commentable)}_path", commentable)
  end


  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_commented_object
    @commented_object = if params[:post_id].present?
                          Post.find(params[:post_id])
                        else
                          Comment.find(params[:comment_id])
                        end
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def send_comment_notification(commented_object)
    return if commented_object.user == current_user

    send_notification({ receiver_id: commented_object.user.id,
                        object_type: 'Comment',
                        description: notification_description(commented_object),
                        time_sent: Time.zone.now.to_s,
                        object_url: determine_path(commented_object) })
  end

  def notification_description(commented_object)
    class_string = object_to_s(commented_object)
    descriptions = {
      'Comment' => "replied to your #{class_string}",
      'Post' => "commented on your #{class_string}"
    }
    descriptions[commented_object.class.to_s]
  end

  def check_comment_ownership
    user_id = if params[:comment]
                params[:comment][:user_id].to_i
              else
                @comment.user.id
              end
    redirect_to root_url, alert: 'Not allowed!' unless user_id == current_user.id
  end
end
