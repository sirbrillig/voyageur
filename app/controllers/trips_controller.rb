class TripsController < ApplicationController
  def clear
    @trip = Trip.find(params[:id])

    @trip.locations.clear

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end
end
