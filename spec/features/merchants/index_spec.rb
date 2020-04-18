require 'rails_helper'

RSpec.describe 'merchant index page', type: :feature do
  describe 'As a user' do
    before :each do      
      @user_admin = User.create!(name: "Jordan Sewell", address:"321 Fake St.", city: "Arvada", state: "CO", zip: "80301", email: "chunky_admin@example.com", password: "123password", role: 2)
      visit "/login"
      fill_in :Email, with: @user_admin.email
      fill_in :Password, with: @user_admin.password
      click_button "Login"
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
    end

    it 'I can see a list of merchants in the system' do
      visit '/admin/merchants'

      expect(page).to have_link("Brian's Bike Shop")
      expect(page).to have_link("Meg's Dog Shop")
    end

    it 'I can see a link to create a new merchant' do
      visit '/admin/merchants'

      expect(page).to have_link("New Merchant")

      click_on "New Merchant"

      expect(current_path).to eq("/admin/merchants/new")
    end
  end
end
