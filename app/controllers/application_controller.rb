include ActionController::HttpAuthentication::Basic::ControllerMethods

class ApplicationController < ActionController::API

  rescue_from ActiveRecord::RecordNotFound do
    render :status => :not_found
  end

  rescue_from ActionController::UnpermittedParameters do
    render :status => :bad_request
  end

  private
  def authenticate
    if user = authenticate_with_http_basic { |u, p|
        user = User.find_by(email: u)
        user.authenticate(p) if user.present?
      }
        @current_user = user
    else
      request_http_basic_authentication
    end
  end

end
