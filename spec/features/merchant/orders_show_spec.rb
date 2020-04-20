require 'rails_helper'

RSpec.describe "as a merchant employee, when i visit my merchant dashboard", type: :feature do
  context "if my items are on any orders, i see a list of these orders and" do
    it "i see order id as link to order show, date, total qty and total value of my items" do

      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      dog_bowl = dog_shop.items.create(name: "Dog Bowl", description: "Great dog bowl!", price: 7, image: "https://www.talltailsdog.com/pub/media/catalog/product/cache/a0f79b354624f8eb0e90cc12a21406d2/u/n/untitled-6.jpg", inventory: 32)
      dog_ball = dog_shop.items.create(name: "Dog Ball", description: "Awesome dog ball!", price: 5, image: "https://img.chewy.com/is/image/catalog/59155_MAIN._AC_SL1500_V1518033665_.jpg", inventory: 20)
      dog_leash = dog_shop.items.create(name: "Dog Leash", description: "Sturdy dog leash!", price: 10, image: "https://cdn.shopify.com/s/files/1/1728/3089/products/max_and_neo_small_dog_leash_black.jpg?v=1555617800", inventory: 11)
      employee = dog_shop.users.create!(
        name: "Steve",
        address:"123 Main St.",
        city: "Fort Collins",
        state: "GA",
        zip: "66666",
        email: "chunky_lover@example.com",
        password: "123password",
        role: 1
      )
      user1 = User.create(name: 'Steve Meyers', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', email: "user1@example.com", password: "user1")
      user2 = User.create(name: 'Jordan Sewell', address: '123 Fake St.', city: 'Arvada', state: 'CO', zip: '80301', email: "user2@example.com", password: "user2")
      order0 = user1.orders.create(name: 'Steve Meyers', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', status: 0)
      order1 = user1.orders.create(name: 'Steve Meyers', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', status: 3)
      order2 = user2.orders.create(name: 'Jordan Sewell', address: '123 Fake St.', city: 'Arvada', state: 'CO', zip: '80301', status: 2)
      order3 = user1.orders.create(name: 'Steve Meyers', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', status: 1)
      order4 = user2.orders.create(name: 'Jordan Sewell', address: '123 Fake St.', city: 'Arvada', state: 'CO', zip: '80301', status: 0)
      ItemOrder.create(item: tire, order: order0, price: tire.price, quantity: 2)
      ItemOrder.create(item: dog_bone, order: order1, price: dog_bone.price, quantity: 4)
      ItemOrder.create(item: pull_toy, order: order2, price: pull_toy.price, quantity: 7)
      ItemOrder.create(item: dog_ball, order: order2, price: dog_ball.price, quantity: 3)
      ItemOrder.create(item: dog_bowl, order: order2, price: dog_bowl.price, quantity: 2)
      ItemOrder.create(item: pull_toy, order: order3, price: pull_toy.price, quantity: 4)
      ItemOrder.create(item: dog_leash, order: order4, price: dog_leash.price, quantity: 3)
      ItemOrder.create(item: tire, order: order4, price: tire.price, quantity: 2)
      
      visit "/login"
      fill_in :Email, with: employee.email
      fill_in :Password, with: employee.password
      click_button "Login"
      expect(current_path).to eq("/merchant/dashboard")
      
      expect(page).to have_content("Order ID: #{order4.id}")
      expect(page).to have_content("Date Created: #{order4.created_at.to_date}")
      expect(page).to have_content("Merchant Items: #{order4.merchant_order_items_count(dog_shop.id)}")
      expect(page).to have_content("Total Merchant Items Value: $30.00")
      expect(page).to have_no_content("Order ID: #{order0.id}")
      expect(page).to have_no_content("Order ID: #{order1.id}")
      expect(page).to have_no_content("Order ID: #{order2.id}")
      expect(page).to have_no_content("Order ID: #{order3.id}")
      
      click_link("#{order4.id}")
      expect(current_path).to eq("/merchant/orders/#{order4.id}")
      
      expect(page).to have_content("Order #{order4.id} Info")
      expect(page).to have_content("Date Placed: #{order4.created_at.to_date}")
      expect(page).to have_content("Date Last Updated: #{order4.updated_at.to_date}")
      expect(page).to have_content("Status: #{order4.status}")
      expect(page).to have_content("Total Item Quantity: #{order4.total_item_quantity}")
      expect(page).to have_content("Total: $#{order4.grandtotal}0")
      expect(page).to have_content("Status: #{order4.status}")
    end
  end
  
  context 'when I visit my order show page' do
    it 'I see the recepients name and address that was used to create this order' do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      dog_leash = dog_shop.items.create(name: "Dog Leash", description: "Sturdy dog leash!", price: 10, image: "https://cdn.shopify.com/s/files/1/1728/3089/products/max_and_neo_small_dog_leash_black.jpg?v=1555617800", inventory: 11)
      employee = dog_shop.users.create!(
        name: "Steve",
        address:"123 Main St.",
        city: "Fort Collins",
        state: "GA",
        zip: "66666",
        email: "chunky_lover@example.com",
        password: "123password",
        role: 1
      )
      user1 = User.create(name: 'Steve Meyers', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', email: "user1@example.com", password: "user1")
      user2 = User.create(name: 'Jordan Sewell', address: '123 Fake St.', city: 'Arvada', state: 'CO', zip: '80301', email: "user2@example.com", password: "user2")
      order0 = user1.orders.create(name: 'Steve Meyers', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', status: 0)
      ItemOrder.create(item: dog_leash, order: order0, price: dog_leash.price, quantity: 2)

      visit "/login"
      fill_in :Email, with: employee.email
      fill_in :Password, with: employee.password
      click_button "Login"

      visit "/merchant/orders/#{order0.id}"
      expect(page).to have_content(user1.name)
      expect(page).to have_content(user1.address)
      expect(page).to have_content(user1.state)
      expect(page).to have_content(user1.city)
      expect(page).to have_content(user1.zip)
      expect(page).to_not have_content(user2.name)
    end
    
    it 'I only see the items in the order that are from my merchant' do
      
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      dog_bowl = dog_shop.items.create(name: "Dog Bowl", description: "Great dog bowl!", price: 7, image: "https://www.talltailsdog.com/pub/media/catalog/product/cache/a0f79b354624f8eb0e90cc12a21406d2/u/n/untitled-6.jpg", inventory: 32)
      dog_ball = dog_shop.items.create(name: "Dog Ball", description: "Awesome dog ball!", price: 5, image: "https://img.chewy.com/is/image/catalog/59155_MAIN._AC_SL1500_V1518033665_.jpg", inventory: 20)
      dog_leash = dog_shop.items.create(name: "Dog Leash", description: "Sturdy dog leash!", price: 10, image: "https://cdn.shopify.com/s/files/1/1728/3089/products/max_and_neo_small_dog_leash_black.jpg?v=1555617800", inventory: 11)
      employee = dog_shop.users.create!(
        name: "Steve",
        address:"123 Main St.",
        city: "Fort Collins",
        state: "GA",
        zip: "66666",
        email: "chunky_lover@example.com",
        password: "123password",
        role: 1
      )
      user1 = User.create(name: 'Steve Meyers', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', email: "user1@example.com", password: "user1")
      order1 = user1.orders.create(name: 'Steve Meyers', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', status: 0)
    
      ItemOrder.create(item: tire, order: order1, price: tire.price, quantity: 2)
      ItemOrder.create(item: dog_bone, order: order1, price: dog_bone.price, quantity: 4)
      
      visit "/login"
      fill_in :Email, with: employee.email
      fill_in :Password, with: employee.password
      click_button "Login"

      visit "/merchant/orders/#{order1.id}"
      expect(page).to have_content(dog_bone.name)
      expect(page).to_not have_content(tire.name)
    end

    it 'if I have not already fulfilled the item, I can click a button to do so' do
      
      dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      dog_bowl = dog_shop.items.create(name: "Dog Bowl", description: "Great dog bowl!", price: 7, image: "https://www.talltailsdog.com/pub/media/catalog/product/cache/a0f79b354624f8eb0e90cc12a21406d2/u/n/untitled-6.jpg", inventory: 32)
      dog_ball = dog_shop.items.create(name: "Dog Ball", description: "Awesome dog ball!", price: 5, image: "https://img.chewy.com/is/image/catalog/59155_MAIN._AC_SL1500_V1518033665_.jpg", inventory: 20)
      dog_leash = dog_shop.items.create(name: "Dog Leash", description: "Sturdy dog leash!", price: 10, image: "https://cdn.shopify.com/s/files/1/1728/3089/products/max_and_neo_small_dog_leash_black.jpg?v=1555617800", inventory: 11)
      employee = dog_shop.users.create!(
        name: "Steve",
        address:"123 Main St.",
        city: "Fort Collins",
        state: "GA",
        zip: "66666",
        email: "chunky_lover@example.com",
        password: "123password",
        role: 1
      )
      user1 = User.create(name: 'Steve Meyers', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', email: "user1@example.com", password: "user1")
      order1 = user1.orders.create(name: 'Steve Meyers', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', status: 0)
    
      ItemOrder.create(item: dog_ball, order: order1, price: dog_ball.price, quantity: 2)
      ItemOrder.create(item: dog_bone, order: order1, price: dog_bone.price, quantity: 4)
      
      visit "/login"
      fill_in :Email, with: employee.email
      fill_in :Password, with: employee.password
      click_button "Login"

      visit "/merchant/orders/#{order1.id}"
      
      within("#item-#{dog_bone.id}") do
        click_button "Fulfill"
      end

    end
  
    it 'when I click Fulfill I see a flash message and text indicating that it has been fulfilled, I am returned to the order show page, the button is gone, and the inventory is permanently decreased ' do
      
      dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      dog_bowl = dog_shop.items.create(name: "Dog Bowl", description: "Great dog bowl!", price: 7, image: "https://www.talltailsdog.com/pub/media/catalog/product/cache/a0f79b354624f8eb0e90cc12a21406d2/u/n/untitled-6.jpg", inventory: 32)
      dog_ball = dog_shop.items.create(name: "Dog Ball", description: "Awesome dog ball!", price: 5, image: "https://img.chewy.com/is/image/catalog/59155_MAIN._AC_SL1500_V1518033665_.jpg", inventory: 20)
      dog_leash = dog_shop.items.create(name: "Dog Leash", description: "Sturdy dog leash!", price: 10, image: "https://cdn.shopify.com/s/files/1/1728/3089/products/max_and_neo_small_dog_leash_black.jpg?v=1555617800", inventory: 11)
      employee = dog_shop.users.create!(
        name: "Steve",
        address:"123 Main St.",
        city: "Fort Collins",
        state: "GA",
        zip: "66666",
        email: "chunky_lover@example.com",
        password: "123password",
        role: 1
      )
      user1 = User.create(name: 'Steve Meyers', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', email: "user1@example.com", password: "user1")
      order1 = user1.orders.create(name: 'Steve Meyers', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', status: 0)
    
      ItemOrder.create(item: dog_ball, order: order1, price: dog_ball.price, quantity: 2)
      ItemOrder.create(item: dog_bone, order: order1, price: dog_bone.price, quantity: 4)
      
      visit "/login"
      fill_in :Email, with: employee.email
      fill_in :Password, with: employee.password
      click_button "Login"

      visit "/merchant/orders/#{order1.id}"
      
      within("#item-#{dog_bone.id}") do
        click_button "Fulfill"
      end

      expect(current_path).to eq("/merchant/orders/#{order1.id}")
      
      expect(page).to have_content("#{dog_bone.name} was succesfully fulfilled!")      
     
      within("#item-#{dog_bone.id}") do
        expect(page).to_not have_button("Fulfill")
        expect(page).to have_content('Fulfilled')
      end
      new_dog_bone = ItemOrder.last.item
      expect(new_dog_bone.inventory).to eq(17)
    end

    it 'if the users desired quantity is greater than my inventory there is a message saying I cannot fulfill no Fulfill button ' do  
      dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 5)
      employee = dog_shop.users.create!(
        name: "Steve",
        address:"123 Main St.",
        city: "Fort Collins",
        state: "GA",
        zip: "66666",
        email: "chunky_lover@example.com",
        password: "123password",
        role: 1
      )
      user1 = User.create(name: 'Steve Meyers', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', email: "user1@example.com", password: "user1")
      order1 = user1.orders.create(name: 'Steve Meyers', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', status: 0)
    
      ItemOrder.create(item: pull_toy, order: order1, price: pull_toy.price, quantity: 7)
      
      visit "/login"
      fill_in :Email, with: employee.email
      fill_in :Password, with: employee.password
      click_button "Login"

      visit "/merchant/orders/#{order1.id}"
      
      within("#item-#{pull_toy.id}") do
        expect(page).to_not have_button "Fulfill"
        expect(page).to have_content("You do not have enough stock to fulfill this order!")
      end
    end
  end
end
