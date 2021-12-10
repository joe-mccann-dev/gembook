class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :profile_viewable?, only: [:show]

  def index
    @friendship = Friendship.new
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @post = Post.new
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def profile_viewable?
    return if current_user == @user

    unless current_user.friends.include?(@user)
      redirect_to root_url
      flash[:info] = "You must be friends to view this user's profile."
    end
  end
end
