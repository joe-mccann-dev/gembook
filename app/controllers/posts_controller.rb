class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action -> { prevent_unauthorized_posting(params[:post][:user_id]) }, only: [:create]

  def index
    @posts = timeline_posts
  end

  def timeline_posts
    Post.includes([:user])
        .where(user_id: [current_user.id, current_user.friends.map(&:id)].flatten)
        .order(created_at: :desc)
  end

  def create
    @post = current_user.posts.build(content: params[:post][:content])
    if @post.save
      flash[:info] = 'Post created successfully'
    else
      flash[:warning] = 'Failed to create post. Please try again.'
    end
    redirect_to user_path(params[:post][:user_id])
  end

  def show
    @post = Post.find(params[:id])
  end

  private

  # in case users try to submit a post as someone else via the command line
  def prevent_unauthorized_posting(user_id)
    @user = User.find(user_id)
    if @user != current_user
      redirect_to user_path(user_id)
      flash[:warning] = 'Unallowed!'
    end
  end


end
