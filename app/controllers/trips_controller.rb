class TripsController < ApplicationController

  def remove
    @trip = Trip.find(params[:id])

    @trip.locations.delete_at(params[:index].to_i) # FIXME: this is not working; possibly because the trip.locations thing is unordered?

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
