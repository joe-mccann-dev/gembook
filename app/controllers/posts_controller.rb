class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, except: [:new, :create, :index]
  before_action :build_post, only: [:create]
  before_action :check_post_ownership, only: [:create, :update, :destroy]
  before_action -> { verify_object_viewable(@post) }, only: [:show]

  def index
    @posts = timeline_posts
    @comment = current_user.comments.build
    @post = current_user.posts.build
  end

  def timeline_posts
    Post.with_attached_image.includes([:image_attachment, :user, :likes, :likers, comments: [:likes, :likers]])
        .where(user_id: [current_user.id, current_user.friends.map(&:id)].flatten)
        .order(created_at: :desc)
  end

  def new
    @post = current_user.posts.build
  end

  def create
    if @post.save
      flash[:success] = 'Post created successfully.'
      redirect_to request.referrer
    else
      flash[:warning] = 'Failed to create post. Please try again.'
      render :new
    end
  end

  def update
    if @post.update(post_params)
      flash[:success] = 'Post successfully edited.'
      redirect_to post_path(@post)
    else
      render :edit
      flash[:warning] = 'Failed to update post'
    end
  end

  def destroy
    if @post.destroy
      flash[:info] = 'Post successfully removed.'
    else
      flash[:warning] = "Failed to remove post."
    end
    redirect_to root_url
  end

  def show
    @comment = Comment.new
  end

  def edit; end

  private

  def post_params
    params.require(:post).permit(:content, :image)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def build_post
    @post = current_user.posts.build(post_params)
  end

  def check_post_ownership
    user_id = @post.user_id
    redirect_to root_url, alert: 'Not allowed!' unless user_id == current_user.id
  end
end
