class UsersController < ApplicationController

  #POST
  def create
    user = User.new(user_params)
   
      if user.create_user
        render json: { message: "User created successfully", user: {
          user_id: user.user_id,
          name: user.name,
          email: user.email,
          role: user.role,
          introduction: user.introduction
        } }, status: :created
      else
        render json:{ message: "Failed to create user", errors: user.errors.full_messages }, status: :unprocessable_entity 
      end
    
  end

  #GET
  def index
    users = Rails.cache.read('users') || []
    render json: users, status: :ok
  end
  
  #GET user/:id
  def show
    user_id = params[:id]
    users = Rails.cache.read('users') || []
    user = users.find { |usr| usr[:user_id] == user_id}

    if user
      render json: user, status: :ok
    else
      render json: {error: "User not found"}, status: :not_found
    end
  end
  
  private 

  def user_params
    params.require(:user).permit(:name, :email, :password, :role, :introduction)
  end
end