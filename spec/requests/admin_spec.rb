require 'spec_helper.rb'

define "the users list" do
  context "without login" do
    it "denies access"
  end

  context "as an regular user" do
    it "denies access"
  end

  context "as an admin" do
    it "lists the users"
  end
end
