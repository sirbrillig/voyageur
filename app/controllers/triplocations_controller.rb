class TriplocationsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @triplocation = Triplocation.where(id: params[:id], user_id: current_user.id).first

    respond_to do |format|
      format.json { render json: @triplocation }
    end
  end

  def update
    @triplocation = Triplocation.where(id: params[:id], user_id: current_user.id).first

    respond_to do |format|
      if @triplocation.update_attributes(params[:triplocation].slice(*Triplocation.accessible_attributes))
        format.json { head :no_content }
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