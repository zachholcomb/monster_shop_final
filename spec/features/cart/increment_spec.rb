require 'rails_helper'

RSpec.describe "As a visitor,", type: :feature do 
  describe "when I have items in my cart and I visit my cart," do 
    it "then, next to each item, I see a button/link to incrememnt the count of items to purchase until there are none left, error when adding beyond remaining inventory." do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      tire2 = bike_shop.items.create(name: "Goodyear", description: "They're good!", price: 150, image: "https://www.adventurecycling.org/sites/default/assets/Image/AdventureCyclist/OnlineFeatures/2018/Goodyear%20Tires/LoganVB_9829.jpg", inventory: 5)

      visit "/items"

      click_on "Goodyear"
      click_on "Add To Cart"

      visit "/cart"

      expect(page).to have_link("Increase Quantity")

      within "#item-quantity-#{tire2.id}" do
        expect(page).to have_content("1")
        click_on "Increase Quantity"
        expect(page).to have_content("2")
        click_on "Increase Quantity"
        click_on "Increase Quantity"
        click_on "Increase Quantity"
        click_on "Increase Quantity"
      end

      expect(page).to have_content("Unable to add item! Inventory has reached 0.")
    end 
  end
end