class SessionController < ApplicationController
  require 'jwt'

  # POST /login
  def create
    email = params[:email]
    password = params[:password]

    user = User.find_by(email: email)

    if user && user.authenticate(password)
      token = generate_jwt(user)
      render json: { 
        message: 'Login successful', 
        token: token, 
        user:
        {id:user.id, 
        name:user.name, 
        role:user.role, 
        introduction:user.introduction} 
      }, status: :ok
    else
      render json: { message: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private
  # Generate a JWT for the user
  def generate_jwt(user)
    
    payload = {
      id: user.id,
      name: user.name,
      role: user.role,
      introduction: user.introduction,
      exp: 24.hours.from_now.to_i
    }
    secret_key = Rails.application.credentials.jwt_secret 
    # || 'default_secret'
    JWT.encode(payload, secret_key, 'HS256')
  end
end