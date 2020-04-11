require 'rails_helper'

RSpec.describe Cart do

  describe "#add_item" do
    it "add item to the cart" do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      tire2 = bike_shop.items.create(name: "Goodyear", description: "They're good for a year!", price: 150, image: "https://www.adventurecycling.org/sites/default/assets/Image/AdventureCyclist/OnlineFeatures/2018/Goodyear%20Tires/LoganVB_9829.jpg", inventory: 20)
      cart = Cart.new(Hash.new(0))
      cart.add_item(tire2.id.to_s)
      expect(cart.contents).to eq({tire2.id.to_s => 1})
    end
  end

  describe "#total_items" do
    it "returns the total amount of items in the cart" do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      tire2 = bike_shop.items.create(name: "Goodyear", description: "They're good for a year!", price: 150, image: "https://www.adventurecycling.org/sites/default/assets/Image/AdventureCyclist/OnlineFeatures/2018/Goodyear%20Tires/LoganVB_9829.jpg", inventory: 20)

      cart = Cart.new(Hash.new(0))

      cart.add_item(tire2.id.to_s)
      expect(cart.total_items).to eq(1)
    end
  end

  describe "#items" do
    it "returns the item quantity" do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      tire2 = bike_shop.items.create(name: "Goodyear", description: "They're good for a year!", price: 150, image: "https://www.adventurecycling.org/sites/default/assets/Image/AdventureCyclist/OnlineFeatures/2018/Goodyear%20Tires/LoganVB_9829.jpg", inventory: 20)

      cart = Cart.new(Hash.new(0))

      cart.add_item(tire2.id.to_s)
      cart.add_item(tire.id.to_s)
      expect(cart.items).to eq({tire2 => 1, tire => 1})
    end
  end
  
  describe "#total" do
    it "returns total for the cart" do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      tire2 = bike_shop.items.create(name: "Goodyear", description: "They're good for a year!", price: 150, image: "https://www.adventurecycling.org/sites/default/assets/Image/AdventureCyclist/OnlineFeatures/2018/Goodyear%20Tires/LoganVB_9829.jpg", inventory: 20)

      cart = Cart.new(Hash.new(0))

      cart.add_item(tire2.id.to_s)
      expect(cart.total).to eq(150)
    end
  end

  describe "#subtotal" do
    it "returns subtotal for the cart" do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      tire2 = bike_shop.items.create(name: "Goodyear", description: "They're good for a year!", price: 150, image: "https://www.adventurecycling.org/sites/default/assets/Image/AdventureCyclist/OnlineFeatures/2018/Goodyear%20Tires/LoganVB_9829.jpg", inventory: 20)

      cart = Cart.new(Hash.new(0))

      cart.add_item(tire2.id.to_s)
      expect(cart.subtotal(tire2)).to eq(150)
    end
  end

  describe "#inc_qty" do
    it "increases the quantity of an item already in cart" do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      tire2 = bike_shop.items.create(name: "Goodyear", description: "They're good for a year!", price: 150, image: "https://www.adventurecycling.org/sites/default/assets/Image/AdventureCyclist/OnlineFeatures/2018/Goodyear%20Tires/LoganVB_9829.jpg", inventory: 20)

      cart = Cart.new(Hash.new(0))

      cart.add_item(tire2.id.to_s)
      expect(cart.inc_qty(tire2)).to eq(1)
    end
  end

  describe "#out_of_stock?" do 
    it "recognizes when item is out of stock" do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = bike_shop.items.create(inventory: 50, name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588")
      tire2 = bike_shop.items.create(inventory: 5, name: "Goodyear", description: "They're good for a year!", price: 150, image: "https://www.adventurecycling.org/sites/default/assets/Image/AdventureCyclist/OnlineFeatures/2018/Goodyear%20Tires/LoganVB_9829.jpg")

      cart = Cart.new(Hash.new(0))

      cart.add_item(tire2.id.to_s)

      expect(cart.out_of_stock?(tire2.id.to_s)).to be false

      cart.add_item(tire2.id.to_s)
      cart.add_item(tire2.id.to_s)
      cart.add_item(tire2.id.to_s)
      cart.add_item(tire2.id.to_s)
    
      expect(cart.out_of_stock?(tire2.id.to_s)).to be true
    end
  end

end