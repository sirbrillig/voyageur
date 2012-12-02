require 'spec_helper'

describe Trip do
  before do
    @trip = Trip.create
    @loc1 = Location.create(:title => 'home', :address => '100 main street, boston, ma')
    @loc2 = Location.create(:title => 'work', :address => '51 main street, worcester, ma')
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
end
