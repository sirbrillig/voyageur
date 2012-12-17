require 'spec_helper'

describe "The Javascript" do
  context "when not logged-in" do
    before do
      @user = FactoryGirl.create(:user)
      @loc1 = FactoryGirl.create(:home_location, user: @user)
      @loc2 = FactoryGirl.create(:work_location, user: @user)
      @loc3 = FactoryGirl.create(:food_location, user: @user)
      @trip1 = Trip.create(user_id: @user.id)
    end

    it "displays the login page for drag-to-append" do
      visit add_location_path(id: @trip1.id, location_id: @loc1.id)
      page.should have_field "user[email]"
    end

    it "displays the login page for drag-to-insert" do
      visit insert_location_path(id: @trip1.id, location_id: @loc3.id, index: 1)
      page.should have_field "user[email]"
    end

    it "displays the login page for drag-to-move" do
      visit move_location_path(id: @trip1.id, location_index: 2, index: 1)
      page.should have_field "user[email]"
    end
  end

  context "when logged-in" do
    before do
      @user = FactoryGirl.create(:user)
      visit root_url
      fill_in('user[email]', :with => @user.email) 
      fill_in('user[password]', :with => @user.password)
      click_button('Log In')

      @loc1 = FactoryGirl.create(:home_location, user: @user)
      @loc2 = FactoryGirl.create(:work_location, user: @user)
      @loc3 = FactoryGirl.create(:food_location, user: @user)
      @trip1 = Trip.create(user_id: @user.id)
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
      end

      context "when moving from the end to the middle" do
        before do
          visit move_location_path(id: @trip1.id, location_index: 2, index: 1)
        end

        it "moves the location to a set index in the trip" do
          @trip1.location_at(1).title.should eq @loc3.title
        end
      end

      context "when moving from the middle to the top" do
        before do
          visit move_location_path(id: @trip1.id, location_index: 1, index: 0)
        end

        it "moves the location to a set index in the trip" do
          @trip1.location_at(0).title.should eq @loc2.title
        end

        it "does not effect the number of elements" do
          @trip1.locations.count.should eq 3
        end
      end

      context "when moving from the top to the bottom" do
        before do
          visit move_location_path(id: @trip1.id, location_index: 0, index: 2)
        end

        it "moves the location to a set index in the trip" do
          @trip1.location_at(2).title.should eq @loc1.title
        end
      end
    end
  end
end
