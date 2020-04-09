require 'rails_helper'

RSpec.describe "As a registered user" do
  context "when I visit my profile page" do
    it "I see all of my profile data on the page except my password" do
      user = User.create!(name: "Steve",
                          address:"123 Main St.",
                          city: "Fort Collins",
                          state: "GA",
                          zip: "66666",
                          email: "chunky_lover@example.com",
                          password: "123password")

      visit "/login"
      fill_in :Email, with: user.email
      fill_in :Password, with: user.password
      click_button "Login"

      expect(page).to have_content("Name: #{user.name}")
      expect(page).to have_content("Address: #{user.address}")
      expect(page).to have_content("City: #{user.city}")
      expect(page).to have_content("State: #{user.state}")
      expect(page).to have_content("Zip: #{user.zip}")
      expect(page).to have_content("Email: #{user.email}")

      expect(page).to_not have_content(user.password)

    end

    it "and I see a link to edit my profile data" do
      user = User.create!(name: "Steve",
                          address:"123 Main St.",
                          city: "Fort Collins",
                          state: "GA",
                          zip: "66666",
                          email: "chunky_lover@example.com",
                          password: "123password")

      visit "/login"
      fill_in :Email, with: user.email
      fill_in :Password, with: user.password
      click_button "Login"

      expect(page).to have_link("Edit My Profile")
    end
  end
end
