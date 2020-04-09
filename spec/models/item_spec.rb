require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      order = Order.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end

    it 'quantity_purchased' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      order1 = Order.create(name: 'Steve', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992')     
      order2 = Order.create(name: 'Steve', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992')
      ItemOrder.create!(item: tire, order: order1, price: tire.price, quantity: 5)
      ItemOrder.create!(item: tire, order: order2, price: tire.price, quantity: 5)

      expect(tire.quantity_purchased).to eq(10)
    end
  end

  describe "class methods" do
    it "self.active_items" do
      brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      pull_toy = brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      dog_bone = brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

      expect(Item.active_items).to eq([pull_toy])
    end

    it ".most_purchased" do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      tire2 = meg.items.create(name: "Goodyear", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      tire3 = meg.items.create(name: "Michellin", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      pull_toy = brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      dog_bone = brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      dog_bowl = brian.items.create(name: "Dog Bowl", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      dog_ball = brian.items.create(name: "Dog Ball", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      dog_treats = brian.items.create(name: "Dog Treats", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      dog_leash = brian.items.create(name: "Dog Leash", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      order1 = Order.create(name: 'Steve',
                      address: '555 Free St.',
                      city: 'Plano',
                      state: 'TX',
                      zip: '88992')
     
      order2 = Order.create(name: 'Steve',
                        address: '555 Free St.',
                        city: 'Plano',
                        state: 'TX',
                        zip: '88992')

      ItemOrder.create!(item: tire,
                        order: order1,
                        price: tire.price,
                        quantity: 5)

      ItemOrder.create!(item: pull_toy,
                        order: order2,
                        price: pull_toy.price,
                        quantity: 4)

      ItemOrder.create!(item: dog_bone,
                        order: order1,
                        price: dog_bone.price,
                        quantity: 3)

      ItemOrder.create!(item: tire,
                        order: order2,
                        price: tire.price,
                        quantity: 5)

      ItemOrder.create!(item: dog_ball,
                        order: order2,
                        price: dog_ball.price,
                        quantity: 2)

      ItemOrder.create!(item: dog_bowl,
                        order: order2,
                        price: dog_bowl.price,
                        quantity: 1)           
      
      expect(Item.most_purchased).to eq([tire, pull_toy, dog_bone, dog_ball, dog_bowl])
    end

    it ".least_purchased" do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      tire2 = meg.items.create(name: "Goodyear", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      pull_toy = brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      dog_bone = brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      dog_bowl = brian.items.create(name: "Dog Bowl", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      dog_ball = brian.items.create(name: "Dog Ball", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      dog_leash = brian.items.create(name: "Dog Leash", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      order1 = Order.create(name: 'Steve', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992')     
      order2 = Order.create(name: 'Steve', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992')
      ItemOrder.create!(item: tire, order: order1, price: tire.price, quantity: 5)
      ItemOrder.create!(item: pull_toy, order: order2, price: pull_toy.price, quantity: 7)
      ItemOrder.create!(item: dog_bone, order: order1, price: dog_bone.price, quantity: 4)
      ItemOrder.create!(item: tire, order: order2, price: tire.price, quantity: 5)
      ItemOrder.create!(item: dog_ball, order: order2, price: dog_ball.price, quantity: 3)
      ItemOrder.create!(item: dog_bowl, order: order2, price: dog_bowl.price, quantity: 2)
      ItemOrder.create!(item: tire2, order: order1, price: tire.price, quantity: 1)
      expect(Item.least_purchased).to eq([dog_leash, tire2, dog_bowl, dog_ball, dog_bone])
    end
  end
end
