require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it { should belong_to :user }
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
  end

  describe 'instance methods' do
    before :each do
      @user = User.create!(name: "Steve",
                          address:"123 Main St.",
                          city: "Fort Collins",
                          state: "GA",
                          zip: "66666",
                          email: "chunky_lover@example.com",
                          password: "123password")
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: @user)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    end

    it 'grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it 'merchant_grandtotal' do
      expect(@order_1.merchant_grandtotal(@meg.id)).to eq(200)
      expect(@order_1.merchant_grandtotal(@brian.id)).to eq(30)
    end

    it 'total_item_quantity' do
      expect(@order_1.total_item_quantity).to eq(5)
    end

    it 'status_to_packaged' do
      order_2 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: @user)

      order_2.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, status: "fulfilled")
      order_2.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3, status: "fulfilled")

      expect(order_2.status).to eq("Pending")

      order_2.status_to_packaged
      expect(order_2.status).to eq("Packaged")
    end

    it 'merchant_order_items_count' do
      expect(@order_1.merchant_order_items_count(@meg.id)).to eq(2)
      expect(@order_1.merchant_order_items_count(@brian.id)).to eq(3)
    end

  end

  describe "class methods" do
    it "sort_status" do
      user = User.create!(name: "Steve Meyers", address:"123 Main St.", city: "Fort Collins", state: "GA", zip: "66666", email: "chunky_lover@example.com", password: "123password")
      admin = User.create!(name: "Jordan Sewell", address:"321 Fake St.", city: "Arvada", state: "CO", zip: "80301", email: "chunky_admin@example.com", password: "123password", role: 2)
      dog_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      dog_ball = dog_shop.items.create(name: "Dog Ball", description: "Awesome dog ball!", price: 5, image: "https://img.chewy.com/is/image/catalog/59155_MAIN._AC_SL1500_V1518033665_.jpg", inventory: 20)
      dog_bowl = dog_shop.items.create(name: "Dog Bowl", description: "Great dog bowl!", price: 7, image: "https://www.talltailsdog.com/pub/media/catalog/product/cache/a0f79b354624f8eb0e90cc12a21406d2/u/n/untitled-6.jpg", inventory: 32)
      order1 = user.orders.create!(name: 'Steve Meyers', address: "123 Main St.", city: "Fort Collins", state: "GA", zip: "66666", status: 0, user: user)
      order1.item_orders.create!(item: pull_toy, order: order1, price: pull_toy.price, quantity: 7)
      order2 = user.orders.create!(name: 'Steve Meyers 2', address: "123 Main St.", city: "Fort Collins", state: "GA", zip: "66666", status: 1, user: user)
      order2.item_orders.create!(item: dog_bone, order: order2, price: dog_bone.price, quantity: 4)
      order3 = user.orders.create!(name: 'Steve Meyers 3', address: "123 Main St.", city: "Fort Collins", state: "GA", zip: "66666", status: 2, user: user)
      order3.item_orders.create!(item: dog_ball, order: order3, price: dog_ball.price, quantity: 3)
      order4 = user.orders.create!(name: 'Steve Meyers 4', address: "123 Main St.", city: "Fort Collins", state: "GA", zip: "66666", status: 3, user: user)
      order4.item_orders.create!(item: dog_bowl, order: order4, price: dog_bowl.price, quantity: 2)

      expect(Order.sort_status).to eq([order2, order1, order3, order4])
    end
  end
end
