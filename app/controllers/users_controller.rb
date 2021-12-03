class UsersController < ApplicationController
  def index
    @friendship = Friendship.new
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @post = Post.new
  end
end
