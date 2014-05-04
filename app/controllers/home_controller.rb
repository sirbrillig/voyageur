class HomeController < ApplicationController
  before_filter :authenticate_admin, only: [:bust]

  def index
    redirect_to locations_path if user_signed_in?
  end

  def ping
    head :ok
  end

  def bust
    Distance.destroy_all
    redirect_to locations_path
  end
end
