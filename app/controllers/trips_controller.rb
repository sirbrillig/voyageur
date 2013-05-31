class TripsController < ApplicationController
  before_filter :authenticate_user!

  def remove
    @trip = Trip.where(id: params[:id], user_id: current_user.id).first

    @trip.remove_location_at(params[:index].to_i)

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { render json: { trip: @trip, locations: @locations } }
    end
  end

  def clear
    @trip = Trip.where(id: params[:id], user_id: current_user.id).first

    @trip.locations.clear

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { render json: { trip: @trip, locations: @locations } }
    end
  end

  def up
    @trip = Trip.where(id: params[:id], user_id: current_user.id).first

    @trip.move_location_up(params[:index].to_i)
    @trip.save

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end

  def down
    @trip = Trip.where(id: params[:id], user_id: current_user.id).first

    @trip.move_location_down(params[:index].to_i)
    @trip.save

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end

  def move
    @trip = Trip.where(id: params[:id], user_id: current_user.id).first
    @locations = current_user.locations

    @trip.move_location(params[:location_index].to_i, to: params[:index].to_i)
    @trip.save

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { render json: {trip: @trip, locations: @locations} } 
    end
  end

  def add
    @trip = Trip.where(id: params[:id], user_id: current_user.id).first
    @location = Location.find(params[:location_id])
    @locations = current_user.locations
    index = nil
    index = params[:index].to_i if params[:index]

    @trip.add_location(@location, index)

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { render json: { trip: @trip, locations: @locations } }
    end
  end

  def show
    @trip = Trip.where(id: params[:id], user_id: current_user.id).first
    @locations = current_user.locations

    respond_to do |format|
      format.html { render partial: 'trip' }
      format.json { render json: {trip: @trip, locations: @locations} } 
    end
  end
end
