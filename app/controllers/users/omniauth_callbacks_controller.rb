class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # See https://github.com/omniauth/omniauth/wiki/FAQ#rails-session-is-clobbered-after-callback-on-developer-strategy
  skip_before_action :verify_authenticity_token, only: :github

  def github
    auth = request.env["omniauth.auth"]
    @user = User.from_omniauth(auth)
    if @user.persisted?
      Profile.attach_and_save_auth_image(auth, @user)
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: "Github") if is_navigational_format?
    else
      session["devise.github_data"] = request.env["omniauth.auth"].except(:extra) # Removing extra as it can overflow some session stores
      flash[:warning] = "Account email is already registered with this site." if User.find_by(email: auth.info.email)
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end