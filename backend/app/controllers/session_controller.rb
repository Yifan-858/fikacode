class SessionController < ApplicationController
  require 'jwt'

  # POST /login
  def create
    email = params[:email]
    password = params[:password]

    # Fetch users from cache
    users = Rails.cache.read('users') || []
    user = users.find { |u| u[:email] == email }

    if user && authenticate_user(user, password)
      token = generate_jwt(user)
      render json: { message: 'Login successful', token: token }, status: :ok
    else
      render json: { message: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  # Authenticate user by comparing the hashed password
  def authenticate_user(user, password)
    BCrypt::Password.new(user[:password_digest]) == password
  end

  # Generate a JWT for the user
  def generate_jwt(user)
    payload = {
      user_id: user[:user_id],
      email: user[:email],
      role: user[:role],
      exp: 24.hours.from_now.to_i
    }
    secret_key = Rails.application.credentials.jwt_secret 
    # || 'default_secret'
    JWT.encode(payload, secret_key, 'HS256')
  end
end