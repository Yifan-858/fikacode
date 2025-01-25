class UserController < ApplicationController

  #POST
  def create
    user = User.new(user_params)

    if user.create_user
      render json: { message: "User created successfully", user: user }, status: :created
    else
      render json:{ message: "Failed to create user", errors: user.errors.full_messages }, status: :unprocessable_entity 
    end
  end

  private 

  def user_params
    params.require(:user).permit(:name, :email, :password, :role, :introduction)
  end
end