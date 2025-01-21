class PingController < ApplicationController
  def show
    render json: { response:"The server is up and running"}, status: :ok
  end
end