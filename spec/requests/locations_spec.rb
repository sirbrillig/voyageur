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
    before do
      within(:css, ".library .location_#{@loc1.id}") { click_link('add_to_trip') }
      within(:css, ".library .location_#{@loc2.id}") { click_link('add_to_trip') }
    end

    it "shows the location in the trip" do
      page.should have_css(".trip .location_#{@loc1.id}")
    end

    it "shows the location at the end of the trip" do
      page.should have_css(".trip .trip_location_1 .location_#{@loc2.id}")
    end
  end

  context "when the 'remove from trip' button is clicked" do
    before do
      within(:css, ".library .location_#{@loc1.id}") { click_link('add_to_trip') }
      within(:css, ".library .location_#{@loc2.id}") { click_link('add_to_trip') }
      within(:css, ".library .location_#{@loc1.id}") { click_link('add_to_trip') }
      within(:css, ".trip .trip_location_0 .location_#{@loc1.id}") { click_link('remove_from_trip') }
    end

    it "removes the location from the trip" do
      page.should_not have_css(".trip .trip_location_0 .location_#{@loc1.id}")
    end

    it "does not affect the other trip locations" do
      page.should have_css(".trip .location_#{@loc2.id}")
    end

    it "does not remove duplicate locations from the trip" do
      page.should have_css(".trip .location_#{@loc1.id}")
    end
  end

  context "when the 'delete location' button is clicked" do
    before do
      within(:css, ".library .location_#{@loc1.id}") { click_link('add_to_trip') }
      within(:css, ".library .location_#{@loc1.id}") { click_link('delete_location') }
    end

    it "removes the location from the library" do
      page.should_not have_css(".library .location_#{@loc1.id}")
    end

    it "removes the location from the trip" do
      page.should_not have_css(".trip .location_#{@loc1.id}")
    end
  end

  context "when the 'clear trip' button is clicked" do
    before do
      within(:css, ".library .location_#{@loc1.id}") { click_link('add_to_trip') }
      click_link('clear_trip')
    end

    it "removes all locations in the trip" do
      page.should_not have_css(".trip .location_#{@loc1.id}")
    end
  end

  context "when the 'move up' button is clicked on a trip location" do
    before do
      within(:css, ".library .location_#{@loc1.id}") { click_link('add_to_trip') }
      within(:css, ".library .location_#{@loc2.id}") { click_link('add_to_trip') }
      within(:css, ".trip .location_#{@loc2.id}") { click_link('move_up') }
    end

    it "moves the location up in the list" do
      page.should have_css(".trip .trip_location_0 .location_#{@loc2.id}")
    end
  end

  context "when the 'move down' button is clicked on a trip location" do
    before do
      within(:css, ".library .location_#{@loc1.id}") { click_link('add_to_trip') }
      within(:css, ".library .location_#{@loc2.id}") { click_link('add_to_trip') }
      within(:css, ".trip .location_#{@loc1.id}") { click_link('move_down') }
    end

    it "moves the location down in the list" do
      page.should have_css(".trip .trip_location_1 .location_#{@loc1.id}")
    end
  end
end
