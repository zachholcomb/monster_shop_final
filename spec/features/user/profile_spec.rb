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
    
    it "and I see a link to all of my orders if there are any" do
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
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
      
      visit "/profile"
      expect(page).to_not have_link("My Orders")

      @order = user.orders.create!(name: user.name, address: user.address, city: user.city, state: user.state, zip: user.zip)

      visit "/profile"
      expect(page).to have_link("My Orders")
      click_on "My Orders"
      expect(current_path).to eq("/profile/orders")
    end
  end
end
