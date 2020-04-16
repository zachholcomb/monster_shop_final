require 'rails_helper'

RSpec.describe "As a registered user,", type: :feature do
  describe "when I visit my profile page, click on edit password link, fill out the new password fields, and click submit," do 
    it "then I am returned to my profile page and I see a flash message telling me that my password is updated." do
      user = User.create!(name: "Steve",
                          address:"123 Main St.",
                          city: "Fort Collins",
                          state: "GA",
                          zip: "66666",
                          email: "chunky_lover@example.com",
                          password: "123password")

      # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit "/login"
      fill_in :Email, with: user.email
      fill_in :Password, with: user.password
      click_button "Login"

      visit '/profile'

      click_on "Edit Password"

      fill_in :Password, with: "password123"
      fill_in :password_confirmation, with: "password123"

      click_on "Update Password"

      expect(current_path).to eq("/profile")
      expect(page).to have_content("Your password has been updated!")
      
      within "nav" do 
        click_on "Logout"
      end

      visit "/"
      
      within "nav" do 
        click_on "Login"
      end
     
      fill_in :Email, with: "chunky_lover@example.com"
      fill_in :Password, with: "password123"
      click_button "Login"

      expect(page).to have_content("You are now logged in!")
    end
  end

  it "when my password and password confirmation do not match I am taken back to the edit page and see a message telling me so" do
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


    visit '/profile'

    click_on "Edit Password"

    fill_in :Password, with: "password123"
    fill_in :password_confirmation, with: "123"

    click_on "Update Password"
    
    expect(page).to have_content("Password and password confirmation do not match!")
    expect(page).to have_current_path("/profile/password/edit")
  end
end