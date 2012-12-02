require 'spec_helper'

describe Location do
  before do
    @loc1 = FactoryGirl.create(:home_location)
    @loc2 = FactoryGirl.create(:work_location)
  end

  it "calculates the distance between one Location and another" do
    dist1 = @loc1.distance_to @loc2
    milage_between_loc1_and_loc2 = 2.7 # It would be better to get this dynamically
    dist1.should eq milage_between_loc1_and_loc2
  end
end
