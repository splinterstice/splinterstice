module Api
  module V1
    class RoomsController < ApplicationController
      # If you're using CSRF protection in your main app, you might want to skip it here:
      skip_before_action :verify_authenticity_token

      before_action :authenticate_user!

      # GET /api/v1/rooms
      # Returns a list of public rooms.
      def index
        rooms = Room.public_rooms
        render json: { rooms: rooms.as_json(only: [:id, :name]) }, status: :ok
      end

      # GET /api/v1/rooms/:id
      # Returns details for a single room along with its messages.
      def show
        room = Room.find(params[:id])
        messages = room.messages.order(created_at: :asc)
        render json: { 
          room: room.as_json(only: [:id, :name]),
          messages: messages.as_json(only: [:id, :content, :room_id, :created_at])
        }, status: :ok
      end

      # POST /api/v1/rooms
      # Creates a new room with the provided parameters.
      def create
        room = Room.new(room_params)
        if room.save
          render json: { status: 'success', room: room.as_json(only: [:id, :name]) }, status: :created
        else
          render json: { status: 'error', errors: room.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      # Strong parameters for room creation.
      def room_params
        params.require(:room).permit(:name)
      end

      # Ensure a user is authenticated.
      # This method should be adapted to your authentication solution.
      def authenticate_user!
        unless current_user
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
      end
    end
  end
end

