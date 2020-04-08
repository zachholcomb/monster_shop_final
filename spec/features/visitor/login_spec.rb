require 'rails_helper'

RSpec.describe "As a visitor when I visit the login page" do
  xit "if I am a regular user I'm redirected to my profile page when I submit valid information" do
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

    expect(current_path).to eq("/profile")
  end

  xit "if I am a merchant user I'm redirected to my merchant dashboard page when I submit valid information" do
    merchant = User.create!(name: "Steve",
                        address:"123 Main St.",
                        city: "Fort Collins",
                        state: "GA",
                        zip: "66666",
                        email: "chunky_merchant@example.com",
                        password: "123password",
                        role: 1)

    visit "/login"

    fill_in :Email, with: "chunky_merchant@example.com"
    fill_in :Password, with: "123password"
    click_button "Login"
    expect(current_path).to eq("/merchant/dashboard")
  end

  xit "if I am an admin user I'm redirected to my admin dashboard page when I submit valid information" do
    admin = User.create!(name: "Steve",
                        address:"123 Main St.",
                        city: "Fort Collins",
                        state: "GA",
                        zip: "66666",
                        email: "chunky_admin@example.com",
                        password: "123password",
                        role: 2)
    visit "/login"

    fill_in :Email, with: "chunky_admin@example.com"
    fill_in :Password, with: "123password"
    click_button "Login"
  end

  xit "if I am any user I see a flash message saying that I am logged in" do
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

    expect(page).to have_content("You are now logged in!")
  end

  xit "if I enter bad credentials I see a flash message saying that I entered an invalid email or password" do
    user = User.create!(name: "Steve",
                        address:"123 Main St.",
                        city: "Fort Collins",
                        state: "GA",
                        zip: "66666",
                        email: "chunky_lover@example.com",
                        password: "123password")

    visit "/login"

    fill_in :Email, with: "skinny_lover@example.com"
    fill_in :Password, with: user.password
    click_button "Login"

    expect(page).to have_content("You entered incorrect credentials.")

    fill_in :Email, with: user.email
    fill_in :Password, with: "boniver888"
    click_button "Login"

    expect(page).to have_content("You entered incorrect credentials.")
  end

  it "if I am a regular user and already logged in I am redirected to my profile page and see a flash message" do
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

    expect(current_path).to eq("/profile")

    visit "/login"
    expect(current_path).to eq("/profile")
    expect(page).to have_content("You are already logged in!")
  end
end
