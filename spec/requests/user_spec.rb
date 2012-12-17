require 'spec_helper'

describe "The user sign-up page" do
  before do
    visit new_user_path
  end

  it "shows the sign-up form" do
    page.should have_field "user[email]"
  end

  context "after signing up" do
    before do
      @user = FactoryGirl.build(:user)
      fill_in "user[email]", with: @user.email
      fill_in "user[password]", with: @user.password
      fill_in "user[password_confirmation]", with: @user.password
      click_button "Sign Up"
    end

    it "brings you to the locations page" do
      page.should have_link_to new_location_path
    end

    it "creates the User" do
      User.find_by_email(@user.email).should_not be_nil
    end
  end
end
