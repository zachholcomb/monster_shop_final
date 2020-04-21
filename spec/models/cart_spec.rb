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

    it "returns total for the cart with discounted items" do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = bike_shop.items.create(inventory: 50, name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588")
      tire2 = bike_shop.items.create(inventory: 5, name: "Goodyear", description: "They're good for a year!", price: 150, image: "https://www.adventurecycling.org/sites/default/assets/Image/AdventureCyclist/OnlineFeatures/2018/Goodyear%20Tires/LoganVB_9829.jpg")
      discount1 = bike_shop.discounts.create!(name: "Flash Sale", percentage: 10, item_amount: 5)
      cart = Cart.new(Hash.new(0))

      cart.add_item(tire.id.to_s)
      cart.add_item(tire2.id.to_s)

      4.times do 
        cart.inc_qty(tire2.id.to_s)
      end

      expect(cart.total).to eq(775)
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

  describe "#subtotal_with_discounts" do
    it "returns subtotal with discounts applied" do
      meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      pull_toy = meg.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      dog_bone = meg.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      discount1 = meg.discounts.create!(name: "Flash Sale", percentage: 10, item_amount: 5)
      discount2 = meg.discounts.create!(name: "Fifty Percent Off 50 items", percentage: 50, item_amount: 50)
      cart = Cart.new(Hash.new(0))
      cart.add_item(tire.id.to_s)
      cart.inc_qty(tire.id.to_s)
      cart.inc_qty(tire.id.to_s)
      cart.inc_qty(tire.id.to_s)
      cart.inc_qty(tire.id.to_s)
      expect(cart.subtotal_with_discounts(tire, 5)).to eq(450)
    end
  end

  describe "#inc_qty" do
    it "increases the quantity of an item already in cart" do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      tire2 = bike_shop.items.create(name: "Goodyear", description: "They're good for a year!", price: 150, image: "https://www.adventurecycling.org/sites/default/assets/Image/AdventureCyclist/OnlineFeatures/2018/Goodyear%20Tires/LoganVB_9829.jpg", inventory: 20)
      cart = Cart.new(Hash.new(0))

      cart.add_item(tire2.id.to_s)

      expect(cart.inc_qty(tire2.id.to_s)).to eq(2)
    end
  end

  describe "#dec_qty" do
    it "decreases the quantity of an item already in cart" do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      tire2 = bike_shop.items.create(name: "Goodyear", description: "They're good for a year!", price: 150, image: "https://www.adventurecycling.org/sites/default/assets/Image/AdventureCyclist/OnlineFeatures/2018/Goodyear%20Tires/LoganVB_9829.jpg", inventory: 20)
      cart = Cart.new(Hash.new(0))

      cart.add_item(tire2.id.to_s)
      cart.inc_qty(tire2.id.to_s)
      
      expect(cart.dec_qty(tire2.id.to_s)).to eq(1)
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

  describe "#decrease_removal?" do
    it "checks if the quantity in the cart is 0" do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = bike_shop.items.create(inventory: 50, name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588")
      tire2 = bike_shop.items.create(inventory: 5, name: "Goodyear", description: "They're good for a year!", price: 150, image: "https://www.adventurecycling.org/sites/default/assets/Image/AdventureCyclist/OnlineFeatures/2018/Goodyear%20Tires/LoganVB_9829.jpg")
      cart = Cart.new(Hash.new(0))

      cart.add_item(tire2.id.to_s)

      expect(cart.decrease_removal?(tire2)).to be true
    end
  end
end