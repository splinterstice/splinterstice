class RoomsController < ApplicationController
  def index
    @current_user = current_user
    redirect_to "/signin" unless @current_user
    @rooms = Room.public_rooms
    @room = Room.new
    @users = User.all_except(@current_user)
  end
  def show
    @current_user = current_user
    @message = Message.new
    @single_room = Room.find(params[:id])
    @messages = @single_room.messages
    @rooms = Room.public_rooms
    @users = User.all_except(@current_user)

    render "index"
  end
  def create
    @room = Room.create(name: params["room"]["name"])
  end
end
