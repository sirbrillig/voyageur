require 'spec_helper.rb'

define "the users list" do
  context "without login" do
    before { visit users_path }

    it "denies access" do
      page.should have_field 'user[email]'
    end
  end

  context "as an regular user" do
    let(:user) { FactoryGirl.create :user }

    before do
      visit users_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_on 'Log In'
      visit users_path
    end

    it "denies access" do
      page.should have_field 'user[email]'
    end
  end

  context "as an admin" do
    let(:user) { FactoryGirl.create :admin }

    before do
      visit users_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_on 'Log In'
      visit users_path
    end

    it "lists the users" do
      page.should have_content user.email
    end
  end
end