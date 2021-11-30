class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
  end

  private

  def send_notification(params = {})
    params[:sender].sent_notifications.create(receiver: params[:receiver],
                                              object_type: params[:object_type],
                                              description: params[:description])
  end

  def mark_notification_as_read(params = {})
    current_user.received_notifications.find_by(object_type: params[:object_type],
                                                sender_id: params[:sender_id])
                .update(read: true)
  end
end
