require 'spec_helper'

describe Trip do
  before do
    @trip = Trip.create
    @loc1 = FactoryGirl.create(:home_location)
    @loc2 = FactoryGirl.create(:work_location)
    @loc3 = FactoryGirl.create(:food_location)
  end

  it "can have many Locations" do
    @trip.add_location @loc1
    @trip.add_location @loc2
    @trip.reload
    @trip.locations.size.should eq 2
  end

  it "can have the same Location twice" do
    @trip.add_location @loc1
    @trip.add_location @loc2
    @trip.add_location @loc1
    @trip.reload
    @trip.locations.size.should eq 3
  end

  it "calculates the distance of the whole trip" do
    @trip.add_location @loc1
    @trip.add_location @loc2
    @trip.add_location @loc1
    dist1 = @loc1.distance_to @loc2
    dist2 = @loc2.distance_to @loc1
    total_dist = dist1 + dist2
    @trip.distance.should eq total_dist
  end

  it "allows the Locations to be reordered" do
    @trip.add_location @loc1 # 0: home
    @trip.add_location @loc2 # 1: work
    @trip.add_location @loc1 # 2: home
    @trip.add_location @loc3 # 3: food
    @trip.move_location(3, to: 1)
    @trip.reload
    @trip.location_at(1).title.should eq @loc3.title # 1: was work, now food
  end

  context "when deleting locations by index" do
    before do
      @trip.add_location @loc1
      @trip.add_location @loc2
      @trip.add_location @loc1
      @trip.add_location @loc3
      @trip.remove_location_at(1)
      @trip.reload
    end

    it "deletes the location" do
      @trip.location_at(1).title.should_not eq @loc2.title
    end

    it "reorders other elements" do
      @trip.location_at(1).title.should eq @loc1.title
      @trip.location_at(2).title.should eq @loc3.title
    end

    it "does not reorder elements above it" do
      @trip.location_at(0).title.should eq @loc1.title
    end
  end
end
