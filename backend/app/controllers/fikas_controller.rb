class FikasController < ApplicationController
  before_action :authenticate_request, only: [:create, :index, :show]
  before_action :authorize_user_for_fika, only: [:show]

 #POST
 def create
  fika =Fika.new(fika_params)
 
    if fika.create_fika
      render json: { message: "Fika invitation created successfully", fika: {
        fika_id: fika.fika_id,
        sender_id: fika.sender_id,
        receiver_id: fika.receiver_id, 
        status: fika.status,
        scheduled_at: fika.scheduled_at
      } }, status: :created
    else
      render json:{ message: "Failed to create fika invitation", errors: fika.errors.full_messages }, status: :unprocessable_entity 
    end
  end

  #GET
  def index
    fikas = Rails.cache.read('fikas') || []
    render json: fikas, status: :ok
  end

  #GET /fika/:id
  def show
    fika_id = params[:id]
    fikas = Rails.cache.read('fikas') || []
    fika = fikas.find { |usr| usr[:fika_id] == fika_id}

    if fika
      render json: fika, status: :ok
    else
      render json: {error: "Fika not found"}, status: :not_found
    end
  end

  private 

  def fika_params
    params.require(:fika).permit(:sender_id, :receiver_id, :status, :scheduled_at)
  end

  def authorize_user_for_fika
    fika_id = params[:id]
    fikas = Rails.cache.read('fikas') || []
    fika = fikas.find { |fika| fika[:fika_id] == fika_id }

    unless fika && (fika[:sender_id] == current_user.id || fika[:receiver_id] == current_user.id)
      render json: { error: "Unauthorized access to this fika invitation" }, status: :unauthorized
    end
  end

  def current_user
    @current_user ||= User.find_by(id: @decoded_token['user_id'])
  end

end
  