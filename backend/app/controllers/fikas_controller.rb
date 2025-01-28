class FikasController < ApplicationController
  before_action :authenticate_request, only: [:index, :show, :update]

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

  #GET fika/:id
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
    params.require(:fika).permit(:status, :scheduled_at)
  end

end
  