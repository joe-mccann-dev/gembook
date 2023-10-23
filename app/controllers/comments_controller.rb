class CommentsController < ApplicationController
  include NotificationsManager

  before_action :set_commented_object, only: [:new, :create]
  before_action :set_comment, except: [:new, :create]
  before_action :build_comment, only: [:create]
  before_action :check_comment_ownership, only: [:create, :update, :destroy]
  before_action -> { verify_object_viewable(@comment) }, only: [:show]
  after_action -> { send_comment_notification(@commented_object) },
               only: [:create]

  def create
    if @comment.save
      html_id = "#comment-#{@comment.id}"
      respond_to do |format|
        format.turbo_stream {}
        format.html {
          flash[:success] = "Successfully created comment"
          redirect_to "#{request.referrer}#{html_id}" || root_url
        }
      end
    else
      flash[:warning] = "Failed to create comment"
      render :new
    end
  end

  def new
    @comment = @commented_object.comments.build
  end

  def show; end

  def edit; end

  def update
    if @comment.update(comment_params)
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@comment) }
        format.html { 
          redirect_to polymorphic_path(@comment.commentable)
          flash[:success] = "Comment was successfully updated"
        }
      end
    else
      render :edit
      flash[:warning] = "Failed to update comment"
    end
  end

  def destroy
    if @comment.destroy
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.remove(@comment) }
        format.html { flash[:info] = "Comment was successfully removed" }
      end
    else
      flash[:warning] = "Failed to remove comment."
      redirect_to polymorphic_path(@comment.commentable)
    end
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

  def build_comment
    @comment = @commented_object.comments.build(comment_params.merge(user: current_user))
  end

  def check_comment_ownership
    user_id = @comment.user_id
    redirect_to root_url, alert: 'Not allowed!' unless user_id == current_user.id
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
end
