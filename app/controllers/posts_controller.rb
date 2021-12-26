class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, except: [:new, :create, :index]
  before_action -> { verify_object_viewable(@post) }, only: [:show]
  before_action :check_post_ownership, except: [:show, :index]

  def index
    @posts = timeline_posts
  end

  def timeline_posts
    Post.includes([:user, :comments, :likes, :likers])
        .where(user_id: [current_user.id, current_user.friends.map(&:id)].flatten)
        .order(created_at: :desc)
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:info] = 'Post created successfully.'
      redirect_to request.referrer
    else
      flash[:warning] = 'Failed to create post. Please try again.'
      render :new
    end
  end

  def update
    if @post.update(post_params)
      flash[:info] = 'Post successfully edited.'
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

  def show; end

  def edit; end

  private

  def post_params
    params.require(:post).permit(:content)
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
