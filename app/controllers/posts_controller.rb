class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = timeline_posts
  end

  def create
    @post = Post.find(params[:user_id])
    if @post.save
      flash[:info] = "Post created successfully"
    else
      flash[:warning] = "Failed to create post. Please try again."
    end
    redirect_to user_path(params[:user_id])
  end

  def timeline_posts
    Post.where(id: [current_user.id, current_user.friends.map(&:id)].flatten)
        .order(created_at: :desc)
  end
end
