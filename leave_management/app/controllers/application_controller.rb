class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password ,:designation)}

    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name,  :email, :password, :current_password ,:designation)}

  end

  def after_sign_in_path_for(resource)
    if current_user.designation == "hr"
        users_path
    else
      leaves_path
    end    
end

def after_sign_up_path_for(resource)
   
end

def exception_handling(e)
  logger.error "exception_handling: #{e}"
  status = e.http_status rescue 404
  render json: {status: status, :success => false, mismatch: 'exception', :message => e.message}
end


end
