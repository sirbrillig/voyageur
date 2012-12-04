require 'spec_helper'

describe Trip do
  before do
    @trip = Trip.create
    @loc1 = FactoryGirl.create(:home_location)
    @loc2 = FactoryGirl.create(:work_location)
    @loc3 = FactoryGirl.create(:food_location)
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

  it "allows the Locations to be reordered" do
    @trip.locations << @loc1 << @loc2 << @loc1 << @loc3
    @trip.move_location(3, to: 1)
    @trip.reload
    @trip.locations[1].title.should eq @loc3.title
  end

  it "deletes locations by index" do
    @trip.locations << @loc1 << @loc2 << @loc1 << @loc3
    @trip.remove_location_at(1)
    @trip.reload
    @trip.locations[1].title.should_not eq @loc2.title
  end
end
