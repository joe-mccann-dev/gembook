class CommentsController < ApplicationController
  before_action :set_commented_object, only: [:create]
  before_action :set_comment, only: [:show]
  before_action -> { verify_object_viewable(@comment) }, only: [:show]

  def create
    @comment = @commented_object.comments.build(comment_params.merge(user: current_user))
    if @comment.save
      flash[:info] = "Successfully created comment"
    else
      flash[:warning] = "Failed to create comment"
    end
    redirect_to root_url
  end

  def show
    @comment = Comment.find(params[:id])
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
end
