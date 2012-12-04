require 'spec_helper'

describe "The Location list page" do
  before do
    @loc1 = FactoryGirl.create(:home_location)
    @loc2 = FactoryGirl.create(:work_location)
    visit locations_path
  end

  it "shows locations" do
    page.should have_content @loc2.title
  end

  it "shows a button to add a location" do
    page.should have_link_to new_location_path
  end

  context "when the 'add to trip' button is clicked" do
    it "shows the location in the trip"
  end

  context "when the 'remove from trip' button is clicked" do
    it "removes the location from the trip"

    it "does not affect the other trip locations"
  end

  context "when the 'delete location' button is clicked" do
    it "removes the location from the library"

    it "removes the location from the trip"
  end

  context "when the 'clear trip' button is clicked" do
    it "removes all locations in the trip"
  end
end
