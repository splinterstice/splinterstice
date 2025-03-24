class RegisterController < ApplicationController
  def index
    render "/register/index"
  end

  def create
    user = User.create(username: params[:username])
    if user
      log_in(user)
    else
      render 'new'
    end
  end
end
