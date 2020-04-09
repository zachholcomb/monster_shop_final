require 'rails_helper'

RSpec.describe "As a registered user" do
  context "when I visit my profile page" do
    it "I can click a link to update my profile data" do
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

      click_link "Edit My Profile"

      expect(find_field(:Name).value).to eq("Steve")
      expect(find_field(:Address).value).to eq("123 Main St.")
      expect(find_field(:City).value).to eq("Fort Collins")
      expect(find_field(:State).value).to eq("GA")
      expect(find_field(:Zip).value).to eq("66666")
      expect(find_field(:email).value).to eq("chunky_lover@example.com")

      fill_in :Address, with: "123 2nd St."
      fill_in :City, with: "Fort Worth"

      click_on "Submit"
      expect(current_path).to eq("/profile")
      expect(page).to have_content("Your profile has been updated!")
      expect(page).to have_content("123 2nd St.")
      expect(page).to have_content("Fort Worth")
      expect(page).to_not have_content("123 Main St.")
    end

    it "I cannot update my email to another that is already in use" do
      user_1 = User.create!(name: "Steve",
                          address:"123 Main St.",
                          city: "Fort Collins",
                          state: "GA",
                          zip: "66666",
                          email: "chunky_lover@example.com",
                          password: "123password")

      user_2 = User.create!(name: "Steve",
                          address:"123 Main St.",
                          city: "Fort Collins",
                          state: "GA",
                          zip: "66666",
                          email: "skinny_lover@example.com",
                          password: "123password")

      visit "/login"
      fill_in :Email, with: user_1.email
      fill_in :Password, with: user_2.password
      click_button "Login"

      click_link "Edit My Profile"

      fill_in :Email, with: "skinny_lover@example.com"
      click_on "Submit"

      expect(current_path).to eq("/profile/edit")

      expect(page).to have_content("Email has already been taken")
      expect(find_field(:Name).value).to eq("Steve")
      expect(find_field(:Address).value).to eq("123 Main St.")
    end
  end
end
