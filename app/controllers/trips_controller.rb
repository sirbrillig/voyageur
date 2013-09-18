class TripsController < ApplicationController
  before_filter :authenticate_user!

  def remove
    @trip = Trip.where(id: params[:id], user_id: current_user.id).first

    @trip.remove_location_at(params[:index].to_i)

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { render json: @trip }
    end
  end

  def clear
    @trip = Trip.where(id: params[:id], user_id: current_user.id).first

    @trip.locations.clear

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { render json: @trip }
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

    @trip.move_location(params[:location_index].to_i, to: params[:index].to_i)
    @trip.save
    @trip.reload

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { render json: @trip }
    end
  end

  def add
    @trip = Trip.where(id: params[:id], user_id: current_user.id).first
    @location = Location.where(id: params[:location_id], user_id: current_user.id).first
    unless @trip and @location
      Rails.logger.warn "Add called on trip '#{params[:id]}', for location '#{@location}' but no such trip or location was found or they were not owned by user ID '#{current_user.id}'."
      respond_to do |format|
        format.html { redirect_to locations_url }
        format.json { render json: {} }
      end
    end
    index = nil
    index = params[:index].to_i if params[:index]

    @trip.add_location(@location, index)

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { render json: @trip }
    end
  end

  def show
    @trip = Trip.where(id: params[:id], user_id: current_user.id).first

    respond_to do |format|
      format.html { render partial: 'trip' }
      format.json { render json: @trip }
    end
  end

  def update
    triplocations = params[:trip][:triplocations]
    found_triplocations = []
    errors = []
    triplocations = [] unless triplocations

    triplocations.each do |raw_triplocation|
      triplocation = Triplocation.where(id: raw_triplocation[:id], user_id: current_user.id).first
      if triplocation
        # Update triplocation positions
        errors << triplocation.errors unless triplocation.update_attributes(raw_triplocation.slice(:position))
      else
        # Create triplocations that don't exist
        triplocation = Triplocation.create(raw_triplocation.slice(:trip_id, :location_id, :position))
        errors << triplocation.errors unless triplocation
      end
      found_triplocations << triplocation
    end

    # Remove any triplocations that have been removed from the data
    @trip = Trip.where(id: params[:trip][:id], user_id: current_user.id).first
    @trip.triplocations.each do |triplocation|
      triplocation.destroy unless found_triplocations.include? triplocation
    end

    respond_to do |format|
      if errors.empty?
        format.json { head :no_content }
      else
        format.json { render json: errors, status: :unprocessable_entity }
      end
    end
  end
end
