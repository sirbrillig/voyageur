require 'spec_helper'

describe Trip do
  before do
    @trip = Trip.create
    @loc1 = FactoryGirl.create(:home_location)
    @loc2 = FactoryGirl.create(:work_location)
  end

  it "can have many Locations" do
    @trip.locations << @loc1 << @loc2
    @trip.save
    @trip.reload
    @trip.locations.size.should eq 2
  end

  it "can have the same Location twice" do
    @trip.locations << @loc1 << @loc2 << @loc1
    @trip.save
    @trip.reload
    @trip.locations.size.should eq 3
  end

  it "calculates the distance of the whole trip" do
    @trip.locations << @loc1 << @loc2 << @loc1
    dist1 = @loc1.distance_to @loc2
    dist2 = @loc2.distance_to @loc1
    total_dist = dist1 + dist2
    @trip.distance.should eq total_dist
  end
end
