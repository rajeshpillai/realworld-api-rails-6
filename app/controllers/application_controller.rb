module ActionController
  # Modified from action_controller/metal/strong_parameters.rb
  class Parameters
    def deep_transform_keys!(&block)
      @parameters.deep_transform_keys!(&block)
      self
    end
  end
end


class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  respond_to :json

  before_action :underscore_params!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  def authenticate_user
    if request.headers['Authorization'].present?
      authenticate_or_request_with_http_token do |token|
        begin
          # jwt_payload = JWT.decode(token, Rails.application.secrets.secret_key_base).first
          # 17f0a8486f8914ca71af814f6f5f8b5799866a797684d33200da4cd13737d4dab44adef8f91bc7e5bed8c99b4893b5549fcd9d9c5326436c203cfb9e7e265f5f
          jwt_payload = JWT.decode(token, "17f0a8486f8914ca71af814f6f5f8b5799866a797684d33200da4cd13737d4dab44adef8f91bc7e5bed8c99b4893b5549fcd9d9c5326436c203cfb9e7e265f5f").first
          @current_user_id = jwt_payload['id']
        rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
          head :unauthorized
        end
      end
    end
  end

  def authenticate_user!(options = {})
    head :unauthorized unless signed_in?
  end

  def current_user
    @current_user ||= super || User.find(@current_user_id)
  end

  def signed_in?
    @current_user_id.present?
  end

  def underscore_params!
    params.deep_transform_keys!(&:underscore)
  end

end
