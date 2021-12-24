class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :destroy]
  before_action -> { verify_object_viewable(@post) }, only: [:show]
  # before_action -> { prevent_unauthorized_posting(params[:post][:user_id]) }, only: [:create]
  before_action :check_post_ownership, only: [:create, :destroy]

  def index
    @posts = timeline_posts
  end

  def timeline_posts
    Post.includes([:user, :comments, :likes, :likers])
        .where(user_id: [current_user.id, current_user.friends.map(&:id)].flatten)
        .order(created_at: :desc)
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:info] = 'Post created successfully.'
    else
      flash[:warning] = 'Failed to create post. Please try again.'
    end
    # redirect_to user_path(params[:post][:user_id])
    redirect_to request.referrer
  end

  def destroy
    if @post.destroy
      flash[:info] = 'Post successfully removed.'
    else
      flash[:warning] = "Failed to remove post."
    end
    redirect_to request.referrer
  end

  def show
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

  # in case users try to submit a post as someone else via the command line
  def prevent_unauthorized_posting(user_id)
    @user = User.find(user_id)
    if @user != current_user
      redirect_to user_path(user_id)
      flash[:warning] = 'Unallowed!'
    end
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def check_post_ownership
    user_id = if params[:post]
                params[:post][:user_id].to_i
              else
                @post.user.id
              end
    redirect_to root_url, alert: 'Not allowed!' unless user_id == current_user.id
  end
end
