require 'spec_helper'

describe "The home page" do
  let(:user) { FactoryGirl.create :user }

  context "without signing up" do
    before do
      visit root_url
    end

    it "brings you to the home page" do
      page.should_not have_link_to new_location_path
    end
  end

  context "after confirming" do
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_on 'Sign in'
      visit root_url
    end

    it "brings you to the locations page" do
      page.should have_link_to new_location_path
    end
  end

end
