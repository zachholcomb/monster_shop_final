require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    before(:each) do
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
      @items_in_cart = [@paper,@tire,@pencil]
    end

    it 'Theres a link to checkout' do
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

      visit "/cart"

      expect(page).to have_link("Checkout")

      click_on "Checkout"

      expect(current_path).to eq("/orders/new")
    end
  end

  describe 'When I havent added items to my cart' do
    it 'There is not a link to checkout' do
      visit "/cart"

      expect(page).to_not have_link("Checkout")
    end
  end

  describe "As a vistor" do
    before(:each) do
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
      @items_in_cart = [@paper,@tire,@pencil]
    end
    context "When I have items in my cart" do
      it "I have to either login or register to checkout" do
        visit "/cart"
        expect(page).to have_content('To checkout you must log in or register')
        expect(page).to have_link('register')
        expect(page).to have_link('log in')
        click_link('register')
        expect(page).to have_current_path('/register')
        visit "/cart"
        click_link('log in')
        expect(page).to have_current_path('/login')
        visit "/cart"
        click_link('Checkout')
        expect(page).to have_current_path('/cart')
        expect(page).to have_content('Unable to checkout, please log in or register.')
      end
    end
  end

  describe "As a registered user" do
    before(:each) do
      @user = User.create!(name: "Steve",
                        address:"123 Main St.",
                        city: "Fort Collins",
                        state: "GA",
                        zip: "66666",
                        email: "chunky_lover@example.com",
                        password: "123password")

      visit "/login"
      fill_in :Email, with: @user.email
      fill_in :Password, with: @user.password
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
      @items_in_cart = [@paper,@tire,@pencil]
      @order = @user.orders.create!(name: @user.name, address: @user.address, city: @user.city, state: @user.state, zip: @user.zip)
    end
    
    it "when I have items in my cart and visit my cart, I checkout and am redirected to my profiles orders page" do
      visit "/cart"
      click_link('Checkout')
      expect(current_path).to eq("/orders/new")
      fill_in :name, with: "#{@user.name}"
      fill_in :address, with: "#{@user.address}"
      fill_in :city, with: "#{@user.city}"
      fill_in :state, with: "#{@user.state}"
      fill_in :zip, with: "#{@user.zip}"
      click_button('Create Order')
      expect(page).to have_current_path("/profile/orders")
      expect(page).to have_content("Your order was successfully created")
      expect(page).to have_content("Your Orders")
      expect(page).to have_content("Cart: 0")
    end

    it "when I visit my profiles orders page, I see my orders listed" do
      visit "/profile/orders"
      within "#order-#{@order.id}" do
        expect(page).to have_content("Order - #{@order.id}")
        expect(page).to have_content('Order Status: Pending')
      end
    end
  end
end

# As a registered user
# When I add items to my cart
# And I visit my cart
# I see a button or link indicating that I can check out
# And I click the button or link to check out and fill out order info and click create order
# An order is created in the system, which has a status of "pending"
# That order is associated with my user
# I am taken to my orders page ("/profile/orders")
# I see a flash message telling me my order was created
# I see my new order listed on my profile orders page
# My cart is now empty
