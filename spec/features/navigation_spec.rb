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

      within 'nav' do
        click_link 'Home'
      end

      expect(current_path).to eq('/')

      within 'nav' do
        click_link 'Register'
      end

      expect(current_path).to eq('/register')

      within 'nav' do
        click_link 'Login'
      end

      expect(current_path).to eq('/login')

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

  describe "as a user i see all visitor links plus" do
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

        end
      end
    end
  end

  describe "as a merchant, i see all user links" do
    it "plus a link to my merchant dashboard" do

      user = User.create!(
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
        expect(page).to have_link('Dashboard')
        expect(page).to have_no_link('Login')
        expect(page).to have_content("Logged in as #{user.name}")
      end

    end
  end
end
