class LocationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_admin, only: :audits
  skip_before_filter :verify_authenticity_token, :only => [:update]

  def index
    @locations = current_user.locations

    # Right now each user has only 1 trip, but we're leaving our options open.
    @trip = current_user.trips.first
    @trip = Trip.create(user_id: current_user.id) unless @trip

    respond_to do |format|
      format.html
      format.json { render json: @locations }
    end
  end

  def show
    @location = Location.where(id: params[:id], user_id: current_user.id).first

    respond_to do |format|
      format.json { render json: @location }
    end
  end

  def new
    @location = Location.new

    respond_to do |format|
      format.html
      format.json { render json: @location }
    end
  end

  def edit
    @location = Location.where(id: params[:id], user_id: current_user.id).first
  end

  def create
    @location = Location.new(params[:location])
    @location.user = current_user

    respond_to do |format|
      if @location.save
        format.html { redirect_to locations_url, notice: 'Location was successfully created.' }
        format.json { render json: @location, status: :created, location: @location }
      else
        format.html { render action: "new" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @location = Location.where(id: params[:id], user_id: current_user.id).first

    respond_to do |format|
      if @location.update_attributes(params[:location].slice(:position, :address, :title))
        format.html { redirect_to locations_url, notice: 'Location was successfully updated.' }
        format.json { render json: @location }
      else
        format.html { render action: "edit" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @location = Location.where(id: params[:id], user_id: current_user.id).first
    @location.destroy

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end

  def audits
    @object = Location.where(id: params[:id]).first
  end
end
