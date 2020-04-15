require 'rails_helper'

describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it { should have_many :items }
    it { should have_many(:item_orders).through(:items) }
    it { should have_many(:orders).through(:item_orders) }
    it { should have_many :merchant_employees }
    it { should have_many(:users).through(:merchant_employees) }
  end

  describe 'instance methods' do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    end
    it 'no_orders' do
      expect(@meg.no_orders?).to eq(true)
      user = User.create!(name: "Steve", address:"123 Main St.", city: "Fort Collins", state: "GA", zip: "66666", email: "chunky_lover@example.com", password: "123password")
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: user)
      item_order_1 = order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.no_orders?).to eq(false)
    end

    it 'item_count' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 30, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.item_count).to eq(2)
    end

    it 'average_item_price' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.average_item_price).to eq(70)
    end

    it 'distinct_cities' do
      user = User.create!(name: "Steve", address:"123 Main St.", city: "Fort Collins", state: "GA", zip: "66666", email: "chunky_lover@example.com", password: "123password")
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: user)
      order_2 = Order.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17033, user: user)
      order_3 = Order.create!(name: 'Dao', address: '123 Mike Ave', city: 'Denver', state: 'CO', zip: 17033, user: user)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_2.item_orders.create!(item: chain, price: chain.price, quantity: 2)
      order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.distinct_cities).to eq(["Denver","Hershey"])
    end

    it 'pending_orders' do
      dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      user = User.create!(name: "Steve", address:"123 Main St.", city: "Fort Collins", state: "GA", zip: "66666", email: "chunky_lover@example.com", password: "123password")
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: user)
      order_2 = Order.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17033, user: user)
      order_3 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: user, status: 1)
      order_4 = Order.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17033, user: user, status: 2)
      order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 2)
      order_2.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_3.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 2)
      order_4.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.pending_orders).to eq([order_2])
      expect(dog_shop.pending_orders).to eq([order_1])
    end

    it "deactivate_items" do
      dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", active?: true, inventory: 32)
      dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?: true, inventory: 21)
      dog_bowl = dog_shop.items.create(name: "Dog Bowl", description: "Great dog bowl!", price: 7, image: "https://www.talltailsdog.com/pub/media/catalog/product/cache/a0f79b354624f8eb0e90cc12a21406d2/u/n/untitled-6.jpg", active?: true, inventory: 32)

      dog_shop.deactivate_items

      expect(pull_toy.active?).to eq(false)
      expect(dog_bone.active?).to eq(false)
      expect(dog_bowl.active?).to eq(false)
    end

    it "activate_items" do
      dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", active?: true, inventory: 32)
      dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?: true, inventory: 21)
      dog_bowl = dog_shop.items.create(name: "Dog Bowl", description: "Great dog bowl!", price: 7, image: "https://www.talltailsdog.com/pub/media/catalog/product/cache/a0f79b354624f8eb0e90cc12a21406d2/u/n/untitled-6.jpg", active?: true, inventory: 32)

      dog_shop.activate_items
      
      expect(pull_toy.active?).to eq(true)
      expect(dog_bone.active?).to eq(true)
      expect(dog_bowl.active?).to eq(true)
    end

    it "activate_items" do
      dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", active?: false, inventory: 32)

      dog_shop.activate_items

      expect(pull_toy.active?).to eq(true)
    end

  end
end
