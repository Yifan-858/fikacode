class ApplicationController < ActionController::API

  #JWT Authentication Middleware
  def authenticate_request
    token = request.headers['Authorization']&.split(' ')&.last
    secret_key = Rails.application.credentials.jwt_secret

    begin
      @decoded_token = JWT.decode(token, secret_key, true, { algorithm: 'HS256' })[0]

      @current_user = User.find_by(id: @decoded_token["id"]) 

    rescue JWT::DecodeError => e
      render json: { error: "Unauthorized: #{e.message}, You don't have the access to this action. Please try to login first" }, status: :unauthorized
    end
  end

  def current_user
    @current_user ||= User.find_by(id: @decoded_token["id"])
  end
end
