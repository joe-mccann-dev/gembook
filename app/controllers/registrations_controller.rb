class RegistrationsController < Devise::RegistrationsController

  def create
    super
    UserMailer.welcome_email(resource).deliver if resource.valid?
  end

  protected

  def update_resource(resource, params)
    if resource.provider.present?
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password)
  end
end