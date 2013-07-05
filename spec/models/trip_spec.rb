require 'spec_helper'

describe Trip do
  before do
    @trip = Trip.create
    @user = FactoryGirl.create(:user)
    @loc1 = FactoryGirl.create(:home_location)
    @loc2 = FactoryGirl.create(:work_location)
    @loc3 = FactoryGirl.create(:food_location)
    @loc1.user = @user
    @loc2.user = @user
    @loc3.user = @user
  end

  context "when adding a Location" do
    before do
      @trip.add_location @loc1
    end

    it "creates a Triplocation association" do
      Triplocation.where(trip_id: @trip.id, location_id: @loc1.id).should_not be nil
    end

    it "adds the Location" do
      @trip.locations.should include @loc1
    end
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

  context "when Locations are moved" do
    before do
      @trip.add_location @loc1 # 0: home
      @trip.add_location @loc2 # 1: work
      @trip.add_location @loc1 # 2: home
      @trip.add_location @loc3 # 3: food
      @trip.move_location(3, to: 1)
      @trip.reload
    end

    it "puts the new location at the right index" do
      @trip.location_at(1).title.should eq @loc3.title # 1: was work, now food
    end

    it "moves the other locations down" do
      @trip.location_at(2).title.should eq @loc2.title
    end

    it "does not affect higher locations" do
      @trip.location_at(0).title.should eq @loc1.title
    end
  end

  context "when adding a Location to index 2" do
    before do
      @trip.add_location @loc1
      @trip.add_location @loc2
      @trip.add_location @loc3, 2
      @trip.reload
    end

    it "places the Location at the index" do
      @trip.location_at(2).title.should eq @loc3.title
    end
  end

  context "when adding a Location to index 0" do
    before do
      @trip.add_location @loc1
      @trip.add_location @loc2
      @trip.add_location @loc3, 0
      @trip.reload
    end

    it "places the Location at the index" do
      @trip.location_at(0).title.should eq @loc3.title
    end
    
    it "moves the other Locations down" do
      @trip.location_at(2).title.should eq @loc2.title
    end
  end

  context "when adding a Location to index 1" do
    before do
      @trip.add_location @loc1
      @trip.add_location @loc2
      @trip.add_location @loc3, 1
      @trip.reload
    end

    it "places the Location at the index" do
      @trip.location_at(1).title.should eq @loc3.title
    end
    
    it "moves the other Locations down" do
      @trip.location_at(2).title.should eq @loc2.title
    end
  end

  context "when moving a Location down" do
    before do
      @trip.add_location @loc1
      @trip.add_location @loc2
      @trip.add_location @loc3
      @trip.move_location_down 1
      @trip.reload
    end

    it "moves the Location down in the trip order" do
      @trip.location_at(2).title.should eq @loc2.title
    end
  end

  context "when moving a Location up" do
    before do
      @trip.add_location @loc1
      @trip.add_location @loc2
      @trip.add_location @loc3
      @trip.move_location_up 2
      @trip.reload
    end

    it "moves the Location up in the trip order" do
      @trip.location_at(1).title.should eq @loc3.title
    end
  end

  context "when deleting a location" do
    before do
      @trip.add_location @loc1
      @trip.add_location @loc2
      @trip.remove_location_at(1)
      @trip.reload
    end

    it "removes the associated Triplocation" do
      Triplocation.where(trip_id: @trip.id, location_id: @loc2.id).should be_empty
    end
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
