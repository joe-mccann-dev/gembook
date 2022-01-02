class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update]

  def new
    @profile = Profile.new
  end

  def create
    @profile = current_user.build_profile(profile_params)
    if @profile.save
      flash[:success] = "You've successfully created your profile."
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @profile = Profile.find_by(user_id: params[:user_id])
  end

  def update
    @profile = Profile.find_by(user_id: params[:user_id])
    if @profile.update(profile_params)
      flash[:success] = "You've successfully edited your profile."
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:nickname, :bio, :current_city, :hometown, :profile_picture)
  end

  # prevent unauthorized edits of profile
  def correct_user
    @user = User.find(params[:user_id])
    redirect_to root_url unless @user == current_user
  end
end
