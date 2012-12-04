class TripsController < ApplicationController
  def remove
    @trip = Trip.find(params[:id])

    @trip.remove_location_at(params[:index].to_i)

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end

  def clear
    @trip = Trip.find(params[:id])

    @trip.locations.clear

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end
end
