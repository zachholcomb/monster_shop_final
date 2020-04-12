require 'rails_helper'

RSpec.describe "As an Admin,", type: :feature do 
  describe "when I visit the admin dashboard '/admin'" do 
    it "then I see all order information includiong who placed the order, the order ID, creation date, and sorted status." do 
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

      visit admin_dashboard_path

      expect(page).to have_content("Admin Dashboard")
      within "#order-#{order2.id}" do
        expect(page).to have_content(order2.id)
        expect(page).to have_content(order2.created_at.to_date)
        expect(page).to have_content(order2.status)
        expect(page).to have_link(order2.name)
        click_on order2.name 
        expect(current_path).to eq("/admin/users/#{order2.user.id}")
      end

      visit admin_dashboard_path
      
      within "#order-#{order1.id}" do 
        expect(page).to have_link(order1.name)
        expect(page).to have_content(order1.id)
        expect(page).to have_content(order1.created_at.to_date)
        expect(page).to have_content(order1.status)
      end

      within "#order-#{order3.id}" do 
        expect(page).to have_link(order3.name)
        expect(page).to have_content(order3.id)
        expect(page).to have_content(order3.created_at.to_date)
        expect(page).to have_content(order3.status)
      end

      within "#order-#{order4.id}" do 
        expect(page).to have_link(order4.name)
        expect(page).to have_content(order4.id)
        expect(page).to have_content(order4.created_at.to_date)
        expect(page).to have_content(order4.status)
      end
    end 
  end 
end
