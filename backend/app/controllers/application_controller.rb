class ApplicationController < ActionController::API

  #JWT Authentication Middleware
  def authenticate_request
    token = request.headers['Authorization']&.split(' ')&.last
    secret_key = Rails.application.credentials.jwt_secret

    begin
      @decoded_token = JWT.decode(token, secret_key, true, { algorithm: 'HS256' })[0]
    rescue JWT::DecodeError => e
      render json: { error: "Unauthorized: #{e.message}" }, status: :unauthorized
    end
  end
end
