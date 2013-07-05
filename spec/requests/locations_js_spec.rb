require 'spec_helper'

describe "With Javascript", js: true do

  def wait_for_ajax
    start_time = Time.now
    page.evaluate_script('jQuery.isReady&&jQuery.active==0').class.should_not eql(String) until page.evaluate_script('jQuery.isReady&&jQuery.active==0') or (start_time + 5.seconds) < Time.now do
      sleep 1
    end
  end

  describe "The Location list page" do
    context "when not logged-in" do
      before do
        visit locations_path
        wait_for_ajax
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
      end

      context "with no locations added" do
        it "shows the help box with 'Add a location to the list'" do
          page.should have_content "Add a location to the list"
        end
      end

      context "with one location added" do
        before do
          FactoryGirl.create(:home_location, user: @user)
          visit locations_path
          wait_for_ajax
        end

        it "shows the help box with 'Add another location to the list'" do
          page.should have_content "Add another location to the list"
        end
      end

      context "with three locations added" do
        before do
          @loc1 = FactoryGirl.create(:home_location, user: @user)
          @loc2 = FactoryGirl.create(:work_location, user: @user)
          @loc3 = FactoryGirl.create(:food_location, user: @user)
          visit locations_path
          wait_for_ajax
        end

        it "shows locations" do
          page.should have_content @loc2.title
        end

        it "shows a button to add a location" do
          page.should have_link_to new_location_path
        end

        context "when the 'add to trip' button is clicked" do
          before do
            within(:css, ".library .location_#{@loc1.id}") { find('.add-button').click }
            wait_for_ajax
          end

          it "shows the help box with 'Add another location'" do
            page.should have_content "Add another location to this trip"
          end

          context "for two locations" do
            before do
              within(:css, ".library .location_#{@loc2.id}") { find('.add-button').click }
              wait_for_ajax
            end

            it "shows the location in the trip" do
              page.should have_css(".trip .location_block[data-location-id='#{@loc1.id}']")
            end

            it "shows the location at the end of the trip" do
              page.should have_css(".trip .location_block[data-trip-position='2'][data-location-id='#{@loc2.id}']")
            end
          end
        end

        context "when the 'remove from trip' button is clicked" do
          before do
            within(:css, ".library .location_#{@loc1.id}") { find('.add-button').click }
            within(:css, ".library .location_#{@loc2.id}") { find('.add-button').click }
            within(:css, ".library .location_#{@loc1.id}") { find('.add-button').click }
            wait_for_ajax
            within(:css, ".trip .location_block[data-trip-position='1'][data-location-id='#{@loc1.id}']") { click_link('remove_from_trip') }
            wait_for_ajax
          end

          it "removes the location from the trip" do
            page.should_not have_css(".trip .location_block[data-trip-position='1'][data-location-id='#{@loc1.id}']")
          end

          it "does not affect the other trip locations" do
            page.should have_css(".trip .location_block[data-location-id='#{@loc2.id}']")
          end

          it "does not remove duplicate locations from the trip" do
            page.should have_css(".trip .location_block[data-location-id='#{@loc1.id}']")
          end
        end

        context "when the 'delete location' button is clicked" do
          before do
            within(:css, ".library .location_#{@loc1.id}") { find('.add-button').click }
            wait_for_ajax
            within(:css, ".library .location_#{@loc1.id}") { find('.edit-button').click }
            click_link('delete_location')
            page.driver.browser.switch_to.alert.accept
            wait_for_ajax
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
            within(:css, ".library .location_#{@loc1.id}") { find('.add-button').click }
            wait_for_ajax
            click_link('clear_trip')
            wait_for_ajax
          end

          it "removes all locations in the trip" do
            page.should_not have_css(".trip .location_block[data-location-id='#{@loc1.id}']")
          end

          it "shows the help box with 'Add a location'" do
            page.should have_content "Add a location to this trip"
          end
        end

        context "when a trip location is dragged up one place" do
          before do
            pending "drag-and-drop in selenium doesn't work"
            within(:css, ".library .location_#{@loc1.id}") { find('.add-button').click }
            within(:css, ".library .location_#{@loc2.id}") { find('.add-button').click }
            within(:css, ".library .location_#{@loc3.id}") { find('.add-button').click }
            wait_for_ajax

            element = page.first(:css, ".trip .location_block[data-trip-position='2']")
            target = page.first(:css, ".trip .location_block[data-trip-position='1']")
            element.drag_to(target)
            wait_for_ajax
            wait_for_ajax
          end

          it "moves the location up in the list" do
            page.should have_css(".trip .location_block[data-trip-position='1'][data-location-id='#{@loc2.id}']")
          end

          it "moves the replaced location down in the list" do
            page.should have_css(".trip .location_block[data-trip-position='2'][data-location-id='#{@loc1.id}']")
          end

          context "when reloaded" do
            before do
              visit locations_path
              wait_for_ajax
            end

            it "has still moved the location up in the list" do
              page.should have_css(".trip .location_block[data-trip-position='1'][data-location-id='#{@loc2.id}']")
            end
          end
        end

      end
    end
  end
end
