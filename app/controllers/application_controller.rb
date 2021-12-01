class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
  end

  private

  def send_notification(args = {})
    args[:sender].sent_notifications.create(receiver_id: args[:receiver_id],
                                            object_type: args[:object_type],
                                            description: args[:description],
                                            time_sent: args[:time_sent])
  end

  def mark_notification_as_read(args = {})
    current_user.received_notifications.find_by(object_type: args[:object_type],
                                                sender_id: args[:sender_id],
                                                time_sent: args[:time_sent])
                .update(read: true)
  end
end
