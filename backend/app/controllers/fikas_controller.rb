class FikasController < ApplicationController
  before_action :authenticate_request, only: [:create, :index, :show]
  before_action :authorize_user_for_fika, only: [:show]

  #POST
  def create
    fika =Fika.new(fika_params)
 
    if fika.save
      render json: { message: "Fika invitation created successfully", fika: {
        sender_id: fika.sender_id,
        receiver_id: fika.receiver_id, 
        status: fika.status,
        scheduled_at: fika.scheduled_at,
        fika_id: fika.fika_id,
      } }, status: :created
    else
      render json:{ message: "Failed to create fika invitation", errors: fika.errors.full_messages }, status: :unprocessable_entity 
    end
  end

  #GET
  def index
    fikas = Fika.where(sender_id: current_user.id).or(Fika.where(receiver_id: current_user.id))
    render json: fikas, status: :ok
  end

  #GET /fika/:id
  def show
    fika = Fika.find_by(fika_id:params[:id])

    if fika
      render json: fika, status: :ok
    else
      render json: {error: "Fika not found"}, status: :not_found
    end
  end

  private 

  #strong parameters
  def fika_params
    params.require(:fika).permit(:sender_id, :receiver_id, :status, :scheduled_at)
  end

  def authorize_user_for_fika
    fika = Fika.find_by(fika_id:params[:id])

    unless fika && (fika[:sender_id] == current_user.id || fika[:receiver_id] == current_user.id)
      render json: { error: "Unauthorized access to this fika invitation" }, status: :unauthorized
    end
  end

end
  