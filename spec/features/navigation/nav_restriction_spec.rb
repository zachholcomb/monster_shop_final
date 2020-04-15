require 'rails_helper'

RSpec.describe "Navigation Restrictions", type: :feature do
  describe "As an admin" do
    it "I cannot access restricted routes" do
      user = User.create!(name: "Steve",
                          address:"123 Main St.",
                          city: "Fort Collins",
                          state: "GA",
                          zip: "66666",
                          email: "chunky_lover@example.com",
                          password: "123password",
                          role: 2)

      visit '/login'
      fill_in :Email, with: user.email
      fill_in :Password, with: user.password
      click_button "Login"
      visit '/merchant/dashboard'
      expect(page).to have_content("The page you were looking for doesn't exist (404)")
      visit '/cart'
      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end
  end

  describe "as a regular user i see all visitor links plus" do
    context "i see links to /profile and /logout and" do
      context "i do not see links to /login and /register and" do
        it "i see 'Logged in as <username>'" do

          user = User.create!(
            name: "Steve",
            address:"123 Main St.",
            city: "Fort Collins",
            state: "GA",
            zip: "66666",
            email: "chunky_lover@example.com",
            password: "123password"
          )

          visit "/login"
          fill_in :Email, with: user.email
          fill_in :Password, with: user.password
          click_button "Login"

          within 'nav' do
            expect(page).to have_link('Home')
            expect(page).to have_link('All Items')
            expect(page).to have_link('All Merchants')
            expect(page).to have_link('Cart: 0')
            expect(page).to have_link('Profile')
            expect(page).to have_link('Logout')
            expect(page).to have_no_link('Register')
            expect(page).to have_no_link('Login')
            expect(page).to have_content("Logged in as #{user.name}")
          end

          within 'nav' do
            click_on 'Profile'
          end

          expect(current_path).to eq("/profile")
        end
      end
    end
  end

  describe "as a merchant, i see all user links" do
    it "plus a link to my merchant dashboard" do

      meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      merchant = meg.users.create!(
        name: "Steve",
        address:"123 Main St.",
        city: "Fort Collins",
        state: "GA",
        zip: "66666",
        email: "chunky_lover@example.com",
        password: "123password",
        role: 1
      )

      visit "/login"
      fill_in :Email, with: merchant.email
      fill_in :Password, with: merchant.password
      click_button "Login"

      within 'nav' do
        expect(page).to have_link('Home')
        expect(page).to have_link('All Items')
        expect(page).to have_link('All Merchants')
        expect(page).to have_link('Cart: 0')
        expect(page).to have_link('Profile')
        expect(page).to have_link('Logout')
        expect(page).to have_no_link('Register')
        expect(page).to have_link('Dashboard')
        expect(page).to have_no_link('Login')
        expect(page).to have_content("Logged in as #{merchant.name}")
      end
    end
  end

  describe "As an admin,", type: :feature do
    it "I see the same links as a regular user plus /admin and /admin/user minus /cart." do
      admin = User.create!(
        name: "Steve",
        address:"123 Main St.",
        city: "Fort Collins",
        state: "GA",
        zip: "66666",
        email: "chunky_lover@example.com",
        password: "123password",
        role: 2
      )

      visit "/login"
      fill_in :Email, with: admin.email
      fill_in :Password, with: admin.password
      click_button "Login"

      within 'nav' do
        expect(page).to have_link('Home')
        expect(page).to have_link('All Items')
        expect(page).to have_link('All Merchants')
        expect(page).to have_link('Profile')
        expect(page).to have_link('Logout')
        expect(page).to have_link('Admin Dashboard')
        expect(page).to have_link('See all Users')
        expect(page).to have_content("Logged in as #{admin.name}")
        expect(page).to have_no_link('Register')
        expect(page).to have_no_link('Login')
        expect(page).to have_no_content('Cart: 0')
      end
    end
  end
end
