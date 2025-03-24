class PingController < ApplicationController
  def pong
    render status: :ok, body: 'PONG'
  end
end
