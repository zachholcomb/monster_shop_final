require 'rails_helper'

RSpec.describe 'users create form' do
  it "can register a new user" do
    visit '/register'
    fill_in :Name, with: "Steve"
    fill_in :Address, with: "123 Main St."
    fill_in :City, with: "Fort Collins"
    fill_in :State, with: "GA"
    fill_in :Zip, with: "66666"
    fill_in :Email, with: "chunky_lover@example.com"
    fill_in :Password, with: "123password"
    fill_in :user_password_confirmation, with: "123password"
    click_button "Create User"
    expect(page).to have_current_path("/profile")
    expect(page).to have_content("You are successfully registered and logged in!")
  end

  it "cannot be created with missing information" do
    visit '/register'
    fill_in :Name, with: ""
    fill_in :Address, with: "123 Main St."
    fill_in :City, with: ""
    fill_in :State, with: "GA"
    fill_in :Zip, with: "66666"
    fill_in :Email, with: "chunky_lover@example.com"
    fill_in :Password, with: "123password"
    fill_in :user_password_confirmation, with: "123password"
    click_button "Create User"
    expect(page).to have_content("Name can't be blank and City can't be blank")
  end

  it "cannot be created with an email that already exists" do
    user1 = User.create!(name: "Steve",
                        address:"123 Main St.",
                        city: "Fort Collins",
                        state: "GA",
                        zip: "66666",
                        email: "chunky_lover@example.com",
                        password: "123password")

    visit '/register'
    fill_in :Name, with: "Steve"
    fill_in :Address, with: "123 Main St."
    fill_in :City, with: "Fort Collins"
    fill_in :State, with: "GA"
    fill_in :Zip, with: "66666"
    fill_in :Email, with: "chunky_lover@example.com"
    fill_in :Password, with: "123password"
    fill_in :user_password_confirmation, with: "123password"
    click_button "Create User"
    expect(page).to have_content("Email has already been taken")
    expect(find_field(:Name).value).to eq("Steve")
    expect(find_field(:Address).value).to eq("123 Main St.")
  end
end
