class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @liked_post = Post.find(params[:post_id])
    @like = current_user.likes.build(post: @liked_post)
    if @like.save
      flash[:info] = "You liked #{@liked_post.user.first_name}'s post"
    else
      flash[:warning] = 'Failed to like post'
    end
    redirect_to root_url
  end
end
