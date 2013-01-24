require 'spec_helper.rb'

describe "the users list" do
  context "without login" do
    let(:user) { FactoryGirl.create :user }
    before { visit users_path }

    it "denies access" do
      page.should_not have_content user.email
    end
  end

  context "as an regular user" do
    let(:user) { FactoryGirl.create :user }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_on 'Sign in'
      visit users_path
    end

    it "denies access" do
      page.should_not have_content user.email
    end
  end

  context "as an admin" do
    let(:user) { FactoryGirl.create :admin }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_on 'Sign in'
      visit users_path
    end

    it "lists the users" do
      page.should have_content user.email
    end
  end
end
