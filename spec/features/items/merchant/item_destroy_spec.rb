require 'rails_helper'

RSpec.describe 'As a merchant employee', type: :feature do
  describe 'when I visit an item show page' do
    before :each do 
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @user = @bike_shop.users.create!(name: "Steve", address:"123 Main St.", city: "Fort Collins", state: "GA", zip: "66666", email: "chunky_lover@example.com", password: "123password", role: 1)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end
    
    it 'I can delete an item' do
      visit "/items/#{@chain.id}"

      expect(page).to have_link("Delete Item")

      click_on "Delete Item"

      expect(current_path).to eq("/items")
      expect("item-#{@chain.id}").to be_present
    end

    it 'I can delete items and it deletes reviews' do
      visit "/items/#{@chain.id}"

      click_on "Delete Item"
      expect(Review.where(id:@review_1.id)).to be_empty
    end

    it 'I can not delete items with orders' do 
      order_1 = Order.create!(name: 'Meg', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80218, user: @user)
      order_1.item_orders.create!(item: @chain, price: @chain.price, quantity: 2)

      visit "/items/#{@chain.id}"

      expect(page).to_not have_link("Delete Item")
    end
  end
end
