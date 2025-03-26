module Api
  module V1
    class MessagesController < ApplicationController
      # POST /api/v1/messages
      def create
        @current_user = current_user
        @message = @current_user.messages.create(
          content: msg_params[:content],
          room_id: params[:room_id]
        )

        if @message.persisted?
          render json: { status: 'success', message: @message }, status: :created
        else
          render json: { status: 'error', errors: @message.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def msg_params
        params.require(:message).permit(:content)
      end
    end
  end
end

