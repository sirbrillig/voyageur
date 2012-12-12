require 'spec_helper'

describe "The Javascript" do
  before do
    @loc1 = FactoryGirl.create(:home_location)
    @loc2 = FactoryGirl.create(:work_location)
    @loc3 = FactoryGirl.create(:food_location)
    @trip1 = Trip.create
  end

  context "of the drag-to-append" do
    before do
      visit add_location_path(id: @trip1.id, location_id: @loc1.id)
    end

    it "adds the location to the trip" do
      @trip1.locations.should include @loc1
    end
  end

  context "of the drag-to-insert" do
    before do
      @trip1.add_location @loc1
      @trip1.add_location @loc2
      visit insert_location_path(id: @trip1.id, location_id: @loc3.id, index: 1)
    end

    it "adds the location to a set index in the trip" do
      @trip1.location_at(1).title.should eq @loc3.title
    end
  end

  context "of the drag-to-move" do
    before do
      @trip1.add_location @loc1
      @trip1.add_location @loc2
      @trip1.add_location @loc3
      visit move_location_path(id: @trip1.id, location_index: 2, index: 1)
    end

    it "moves the location to a set index in the trip" do
      @trip1.location_at(1).title.should eq @loc3.title
    end
  end
end
