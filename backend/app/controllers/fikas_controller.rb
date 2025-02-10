class FikasController < ApplicationController
  before_action :authenticate_request, only: [:create, :index, :show, :update_status] #require Authorization in the header
  before_action :authorize_user_for_fika, only: [:show, :update_status]

  #POST /fikas
  def create

    sender = User.find_by(id: fika_params[:sender_id])
    receiver = User.find_by(id: fika_params[:receiver_id])

    if sender.nil? || receiver.nil?
      render json: { message: "Sender or receiver not found" }, status: :unprocessable_entity
      return
    end

    fika =Fika.new(fika_params.merge(
      sender_name: sender.name,
      receiver_name: receiver.name
    ))
  
 
    if fika.save
      render json: { message: "Fika invitation created successfully", fika: {
        sender_id: fika.sender_id,
        sender_name: fika.sender_name,
        receiver_id: fika.receiver_id, 
        receiver_name: fika.receiver_name, 
        status: fika.status,
        scheduled_at: fika.scheduled_at,
        fika_id: fika.fika_id,
      } }, status: :created
    else
      render json:{ message: "Failed to create fika invitation", errors: fika.errors.full_messages }, status: :unprocessable_entity 
    end
  end

  #GET /fikas

  def index
    # fetch fikas sent by the user
    if params[:sender_id].present?
      fikas = Fika.where(sender_id: params[:sender_id])
    # fetch fikas received by the user
    elsif params[:receiver_id].present?
      fikas = Fika.where(receiver_id: params[:receiver_id])
    #fetch all the fikas the user is involved 
    else
      fikas = Fika.where(sender_id: current_user.id).or(Fika.where(receiver_id: current_user.id))
    end

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

  #Patch /fikas/:id/update_status
  def update_status
    fika = Fika.find_by(fika_id: params[:id])

    if fika.nil?
      render json:{ error: "Fika not found"}, status: :not_found
      return
    end

    if fika.update(status: params[:status])
      render json:{ message: "Fika updated successfully", fika:fika}, status: :ok
    else
      render json:{ message: "Failed to update Fika", error: fika.errors.full_messages}, status: :unprocessable_entity
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
  