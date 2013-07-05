require 'spec_helper'

describe Triplocation do
  before do
    @user = FactoryGirl.create(:user)
    @trip = Trip.create { |trip| trip.user = @user }
    @loc1 = FactoryGirl.create(:home_location, user: @user)
    @loc2 = FactoryGirl.create(:work_location, user: @user)
  end

  context "when locations are added to a Trip" do
    before do
      @triploc1 = @trip.add_location @loc1
      @trip.add_location @loc2
    end

    it "the Triplocations are created" do
      @trip.triplocations.count.should eq 2
    end

    it "the Triplocation has reference to the trip" do
      @triploc1.trip_id.should eq @trip.id
    end

    it "the Triplocation has reference to the location" do
      @triploc1.location_id.should eq @loc1.id
    end

    it "the Triplocation has reference to the user" do
      @triploc1.user_id.should eq @trip.user.id
    end

    it "the Triplocation has reference to the position in the Trip" do
      @triploc1.position.should eq 1
    end


    context "and a Triplocation changes position" do
      before do
        @trip.move_location(0, to: 1)
        @triploc1.reload
      end

      it "changes the position attribute" do
        @triploc1.position.should eq 2
      end

    end
  end
end

