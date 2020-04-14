require 'rails_helper'

RSpec.describe "As a registered user when I visit my Profile Orders page" do
  it 'I can click on a link that takes me to the order show page' do
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
    mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
  
    
    order_1 = user.orders.create!(name: user.name, address: user.address, city: user.city, state: user.state, zip: user.zip)
    ItemOrder.create!(item: tire, order: order_1, quantity: 3, price: tire.price)
    ItemOrder.create!(item: paper, order: order_1, quantity: 3, price: paper.price)
    order_2 = user.orders.create!(name: user.name, address: user.address, city: user.city, state: user.state, zip: user.zip)
    ItemOrder.create!(item: tire, order: order_2, quantity: 3, price: tire.price)

    visit "/profile/orders"
    within("#order-#{order_1.id}") do
      click_on ("Order - #{order_1.id}")
    end
    expect(current_path).to eq("/profile/orders/#{order_1.id}")
    
    visit "/profile/orders"
    within("#order-#{order_2.id}") do
      click_on ("Order - #{order_2.id}")
    end
    expect(current_path).to eq("/profile/orders/#{order_2.id}")
  end
  
  it 'and click on the order number I am taken to a page with all the order details' do
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
    mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
  
    
    order_1 = user.orders.create!(name: user.name, address: user.address, city: user.city, state: user.state, zip: user.zip)
    item_order_1 = ItemOrder.create!(item: tire, order: order_1, quantity: 3, price: tire.price)
    item_order_2 = ItemOrder.create!(item: paper, order: order_1, quantity: 3, price: paper.price)
    
    visit "/profile/orders/#{order_1.id}"

    expect(page).to have_content("Order #{order_1.id} Info")
    expect(page).to have_content("Date Placed: #{order_1.created_at}")
    expect(page).to have_content("Date Last Updated: #{order_1.updated_at}")
    expect(page).to have_content("Status: #{order_1.status}")
    expect(page).to have_content("Total Item Quantity: #{order_1.total_item_quantity}")
    expect(page).to have_content("Total: $360.00")
    expect(page).to have_content("Item")
    within("#item-#{tire.id}") do
      expect(page).to have_content(tire.name)
      expect(page).to have_content(tire.description)
      expect(page).to have_css("img[src*='#{tire.image}']")
      expect(page).to have_content(3)
      expect(page).to have_content(tire.price)
      expect(page).to have_content("$300.00")
    end
  end

  it 'I see a link to cancel the order' do
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
    mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
  
    
    order_1 = user.orders.create!(name: user.name, address: user.address, city: user.city, state: user.state, zip: user.zip)
    item_order_1 = ItemOrder.create!(item: tire, order: order_1, quantity: 3, price: tire.price)
    item_order_2 = ItemOrder.create!(item: paper, order: order_1, quantity: 3, price: paper.price)
    
    visit "/profile/orders/#{order_1.id}"

    expect(page).to have_link("Cancel Order")

  end

  it 'When I cancel my order, the order status is updated to cancelled and I see a confirmation message' do
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
    mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
  
    
    order_1 = user.orders.create!(name: user.name, address: user.address, city: user.city, state: user.state, zip: user.zip)
    item_order_1 = ItemOrder.create!(item: tire, order: order_1, quantity: 3, price: tire.price)
    item_order_2 = ItemOrder.create!(item: paper, order: order_1, quantity: 3, price: paper.price)
    
    visit "/profile/orders/#{order_1.id}"

    click_link "Cancel Order"
    expect(page).to have_content("Order #{order_1.id} has been cancelled.")
    expect(current_path).to eq("/profile")
    
    visit "/profile/orders/#{order_1.id}"
    expect(page).to have_content("Cancelled")
    
    visit "/profile/orders"
    within("#order-#{order_1.id}") do
      expect(page).to have_content("Cancelled")
    end
  end
  
  it 'when I click Cancel Order, all ItemOrders are give the status or unfulfilled and quanities returned to inventory' do
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
    mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 9)
    paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 1)
    pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
  
    
    order_1 = user.orders.create!(name: user.name, address: user.address, city: user.city, state: user.state, zip: user.zip)
    ItemOrder.create!(item: tire, order: order_1, quantity: 3, price: tire.price, status: 1)
    ItemOrder.create!(item: paper, order: order_1, quantity: 3, price: paper.price, status: 1)
    
    
    visit "/profile/orders/#{order_1.id}"
    order_1.item_orders.each do |item|
      expect(item.status).to eq("fulfilled")
    end

    click_link "Cancel Order"
    order_test = Order.last

    expect(order_test.item_orders.first.status).to eq("unfulfilled")
    expect(order_test.item_orders.last.status).to eq("unfulfilled")
    expect(order_test.items.first.inventory).to eq(12)
    expect(order_test.items.last.inventory).to eq(4)
  end
  
  it 'when all item in an order have been fulfilled, the order status changes to packaged' do
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
    mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 9)
    paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 1)
    pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
  
    
    order_1 = user.orders.create!(name: user.name, address: user.address, city: user.city, state: user.state, zip: user.zip)
    ItemOrder.create!(item: tire, order: order_1, quantity: 3, price: tire.price, status: 1)
    ItemOrder.create!(item: paper, order: order_1, quantity: 3, price: paper.price, status: 1)
    order_1.status_to_packaged
    visit "/profile/orders/#{order_1.id}"
    expect(page).to have_content("Packaged")
  end
end