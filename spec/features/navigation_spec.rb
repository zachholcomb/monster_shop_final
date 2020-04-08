
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

    end

    it "I cannot access any restricted routes directly" do
      visit '/merchant/dashboard'
      expect(page).to have_content("The page you were looking for doesn't exist (404)")

      visit '/admin/dashboard'
      expect(page).to have_content("The page you were looking for doesn't exist (404)")

      visit '/profile'
      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end
  end

  describe "As a default user" do
    it "I cannot access any restriced routes" do
      user = User.create!(name: "Steve",
                          address:"123 Main St.",
                          city: "Fort Collins",
                          state: "GA",
                          zip: "66666",
                          email: "chunky_lover@example.com",
                          password: "123password")

      visit '/login'
      fill_in :Email, with: user.email
      fill_in :Password, with: user.password
      click_button "Login"
      visit '/merchant/dashboard'
      expect(page).to have_content("The page you were looking for doesn't exist (404)")
      visit '/admin/dashboard'
      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end
  end

  describe "As a merchant" do
    it "I cannot access restricted routes" do
      user = User.create!(name: "Steve",
                          address:"123 Main St.",
                          city: "Fort Collins",
                          state: "GA",
                          zip: "66666",
                          email: "chunky_lover@example.com",
                          password: "123password",
                          role: 1)

      visit '/login'
      fill_in :Email, with: user.email
      fill_in :Password, with: user.password
      click_button "Login"
      visit '/admin/dashboard'
      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end
  end
end
