class HomeController < ApplicationController
  def index
    redirect_to locations_path if user_signed_in?
  end

  def ping
    head :ok
  end
end
