class TriplocationsController < ApplicationController
  before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token, :only => [:create]

  def index
    @triplocations = current_user.trips.first.triplocations

    respond_to do |format|
      format.html
      format.json { render json: @triplocations }
    end
  end

  def show
    @triplocation = Triplocation.where(id: params[:id], user_id: current_user.id).first

    respond_to do |format|
      format.json { render json: @triplocation }
    end
  end

  def create
    @triplocation = Triplocation.create(params[:triplocation].slice(:trip_id, :location_id, :position))
    respond_to do |format|
      if @triplocation
        format.json { render json: @triplocation }
      else
        format.json { render json: @triplocation.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @triplocation = Triplocation.where(id: params[:id], user_id: current_user.id).first

    respond_to do |format|
      if @triplocation.update_attributes(params[:triplocation].slice(:position))
        format.json { render json: @triplocation }
      else
        format.json { render json: @triplocation.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @triplocation = Triplocation.where(id: params[:id], user_id: current_user.id).first
    if @triplocation
      @triplocation.destroy
      respond_to do |format|
        format.json { render json: @triplocation }
      end
    else
      Rails.logger.warn "Destroy called on triplocation '#{params[:id]}', but no such triplocation was found or it was not owned by user ID '#{current_user.id}'."
      respond_to do |format|
        format.json { render json: {} }
      end
    end
  end

end
