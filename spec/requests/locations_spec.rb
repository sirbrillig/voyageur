require 'spec_helper'

describe "Without Javascript" do
  describe "The Location list page" do
    context "when not logged-in" do
      before do
        visit locations_path
      end

      it "displays the login page" do
        page.should have_field "user[email]"
      end
    end

    context "when logged-in" do
      before do
        @user = FactoryGirl.create(:user)
        visit new_user_session_path
        fill_in('user[email]', :with => @user.email) 
        fill_in('user[password]', :with => @user.password)
        click_button('Sign in')

        @loc1 = FactoryGirl.create(:home_location, user: @user)
        @loc2 = FactoryGirl.create(:work_location, user: @user)
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
          page.should have_css(".trip .trip_location_1.location_#{@loc2.id}")
        end
      end

      context "when the 'remove from trip' button is clicked" do
        before do
          pending "This was before we used Triplocations, so this may not work correctly"
          within(:css, ".library .location_#{@loc1.id}") { click_link('add_to_trip') }
          within(:css, ".library .location_#{@loc2.id}") { click_link('add_to_trip') }
          within(:css, ".library .location_#{@loc1.id}") { click_link('add_to_trip') }
          within(:css, ".trip .trip_location_0.location_#{@loc1.id}") { find('#remove_from_trip').click() }
        end

        it "removes the location from the trip" do
          page.should_not have_css(".trip .trip_location_0.location_#{@loc1.id}")
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
          visit edit_location_path(@loc1.id)
          click_link('delete_location')
          visit locations_path
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

    end
  end
end
