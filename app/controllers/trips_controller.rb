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

  def up
    @trip = Trip.find(params[:id])

    @trip.move_location_up(params[:index].to_i)
    @trip.save

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end

  def down
    @trip = Trip.find(params[:id])

    @trip.move_location_down(params[:index].to_i)
    @trip.save

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end

  def move
    @trip = Trip.find(params[:id])

    @trip.move_location(params[:location_index].to_i, to: params[:index].to_i)
    @trip.save

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end

  def add
    @trip = Trip.find(params[:id])
    @location = Location.find(params[:location_id])
    index = params[:index].to_i

    @trip.add_location(@location, index)

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end
end
