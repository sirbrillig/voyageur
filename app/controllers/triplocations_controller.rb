class TriplocationsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @triplocation = Triplocation.where(id: params[:id], user_id: current_user.id).first

    respond_to do |format|
      format.json { render json: @triplocation }
    end
  end

  def update
  end

  def destroy
  end

end
