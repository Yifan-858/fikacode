class UsersController < ApplicationController
  before_action :authenticate_request, only: [:index, :show]

  #POST /users
  def create
    user = User.new(user_params)
   
      if user.save
        render json: { message: "User created successfully", user: {
          id: user.id,
          name: user.name,
          email: user.email,
          role: user.role,
          introduction: user.introduction
        } }, status: :created
      else
        render json:{ message: "Failed to create user", errors: user.errors.full_messages }, status: :unprocessable_entity 
      end
  end

  #GET /users
  def index
    users = User.all
    # get the users except the logged-in user
    users = users.where.not(id: current_user.id) if params[:exclude_current] == "true"

    render json: users, status: :ok
  end
  
  #GET user/:id
  def show
    user= User.find_by(id: params[:id])

    if user
      render json: user, status: :ok
    else
      render json: {error: "User not found"}, status: :not_found
    end
  end
  
  private 

  #strong parameters
  def user_params
    params.require(:user).permit(:name, :email, :password, :role, :introduction)
  end
end