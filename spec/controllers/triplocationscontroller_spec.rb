require 'spec_helper'

describe TriplocationsController do
  context "when logged-in" do
    before do
      @user = FactoryGirl.create(:user)
      sign_in @user

      @trip = Trip.create { |trip| trip.user = @user }
      @loc1 = FactoryGirl.create(:home_location, user: @user)
      @loc2 = FactoryGirl.create(:work_location, user: @user)
      @triploc1 = @trip.add_location @loc1
    end

    describe "GET #show" do
      before do
        get :show, format: :json, id: @triploc1.id
      end

      it "shows the JSON" do
        response.body.should eq @triploc1.to_json
      end
    end

    describe "DELETE #destroy" do
      it "deletes the record" do
        expect{ delete :destroy, format: :json, id: @triploc1.id }.to change(Triplocation, :count).by(-1)
      end
    end

    describe "PUT #update" do
      before do
        temp = @triploc1.attributes
        temp['position'] = 2
        put :update, format: :json, id: @triploc1.id, triplocation: temp
        @triploc1.reload
      end

      it "changes the record" do
        @triploc1.position.should eq 2
      end
    end
  end
end
