require 'spec_helper'

describe Location do
  before do
    @loc1 = FactoryGirl.create(:home_location)
    @loc2 = FactoryGirl.create(:work_location)
  end

  it "calculates the distance between one Location and another" do
    dist1 = @loc1.distance_to @loc2
    milage_between_loc1_and_loc2 = 4266 # It would be better to get this dynamically
    dist1.should eq milage_between_loc1_and_loc2
  end

  it "caches the distance" do
    dist1 = @loc1.distance_to @loc2
    @loc1.cached_distance_to(@loc2).should eq dist1
  end

  it "sets query_sent to true if not using a cached distance" do
    dist1 = @loc1.distance_to @loc2
    @loc1.query_sent.should eq true
  end

  it "sets query_sent to false if using a cached distance" do
    dist1 = @loc1.distance_to @loc2
    dist2 = @loc1.distance_to @loc2
    @loc1.query_sent.should eq false
  end

  it "deletes an old cache" do
    dist1 = @loc1.distance_to @loc2
    cached = Distance.where(origin: @loc1.address, destination: @loc2.address).first
    cached.created_at = Time.now - 3.days
    cached.save
    @loc1.cached_distance_to(@loc2).should be_nil
  end
end
