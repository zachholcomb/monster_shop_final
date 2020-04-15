require 'rails_helper'

RSpec.describe "as an admin, when i click 'Users' link in admin nav bar", type: :feature do
  context "my admin only route is '/admin/users' and i see all system users" do
    it "each name is a user show page link and i see date registered and user type" do

      dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      user1 = User.create(name: "Jordan Regular", address:"321 Fake St.", city: "Arvada", state: "CO", zip: "80301", email: "user@example.com", password: "password_regular")
      user2 = dog_shop.users.create(name: "Jordan Employee", address:"321 Fake St.", city: "Arvada", state: "CO", zip: "80301", email: "merchant@example.com", password: "password_merchant", role: 1)
      user3 = User.create(name: "Jordan Admin", address:"321 Fake St.", city: "Arvada", state: "CO", zip: "80301", email: "admin@example.com", password: "password_admin", role: 2)
      customer1 = User.create(name: 'Steve Meyers', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', email: "user1@example.com", password: "user1")
      customer2 = User.create(name: 'Jordan Sewell', address: '123 Fake St.', city: 'Arvada', state: 'CO', zip: '80301', email: "user2@example.com", password: "user2")

      visit '/'

      within 'nav' do
        expect(page).to_not have_link('See all Users')
      end

      visit "/login"
      fill_in :Email, with: user1.email
      fill_in :Password, with: user1.password
      click_button "Login"

      visit '/'
      within 'nav' do
        expect(page).to_not have_link('See all Users')
        click_link "Logout"
      end

      visit "/login"
      fill_in :Email, with: user2.email
      fill_in :Password, with: user2.password
      click_button "Login"

      within 'nav' do
        expect(page).to_not have_link('See all Users')
        click_link "Logout"
      end

      visit "/login"
      fill_in :Email, with: user3.email
      fill_in :Password, with: user3.password
      click_button "Login"

      within 'nav' do
        expect(page).to have_link('See all Users')
        click_link "See all Users"
      end

      expect(current_path).to eq("/admin/users")
      expect(page).to have_link("#{user1.name}")
      expect(page).to have_content(user1.created_at.to_date)
      expect(page).to have_content(user1.role)
      expect(page).to have_link("#{user2.name}")
      expect(page).to have_content(user2.created_at.to_date)
      expect(page).to have_content(user2.role)
      expect(page).to have_link("#{user3.name}")
      expect(page).to have_content(user3.created_at.to_date)
      expect(page).to have_content(user3.role)
      expect(page).to have_link("#{customer1.name}")
      expect(page).to have_content(customer1.created_at.to_date)
      expect(page).to have_content(customer1.role)
      expect(page).to have_link("#{customer2.name}")
      expect(page).to have_content(customer2.created_at.to_date)
      expect(page).to have_content(customer2.role)

    end
  end
end
