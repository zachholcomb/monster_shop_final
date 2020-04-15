require 'rails_helper'

RSpec.describe "as an admin, when i visit a user profile page", type: :feature do
  it "i see everything the user would see but no link to edit their profile" do

    dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    dog_bowl = dog_shop.items.create(name: "Dog Bowl", description: "Great dog bowl!", price: 7, image: "https://www.talltailsdog.com/pub/media/catalog/product/cache/a0f79b354624f8eb0e90cc12a21406d2/u/n/untitled-6.jpg", inventory: 32)
    dog_ball = dog_shop.items.create(name: "Dog Ball", description: "Awesome dog ball!", price: 5, image: "https://img.chewy.com/is/image/catalog/59155_MAIN._AC_SL1500_V1518033665_.jpg", inventory: 20)
    dog_leash = dog_shop.items.create(name: "Dog Leash", description: "Sturdy dog leash!", price: 10, image: "https://cdn.shopify.com/s/files/1/1728/3089/products/max_and_neo_small_dog_leash_black.jpg?v=1555617800", inventory: 11)

    user1 = User.create(
      name: 'Steve Meyers',
      address: '555 Free St.',
      city: 'Plano',
      state: 'TX',
      zip: '88992',
      email: "user1@example.com",
      password: "userpassword1")
    user2 = User.create(
      name: 'Jordan Sewell',
      address: '123 Fake St.',
      city: 'Arvada',
      state: 'CO',
      zip: '80301',
      email: "user2@example.com",
      password: "userpassword2")

    order1 = user2.orders.create(name: 'Steve Meyers', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', status: 2)
    order2 = user2.orders.create(name: 'Steve Meyers', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992')
    ItemOrder.create(item: dog_bowl, order: order1, price: dog_bowl.price, quantity: 1)
    ItemOrder.create(item: dog_leash, order: order1, price: dog_leash.price, quantity: 1)
    ItemOrder.create(item: dog_ball, order: order2, price: dog_ball.price, quantity: 2)

    admin = User.create(
      name: "Jordan Admin",
      address:"321 Fake St.",
      city: "Arvada",
      state: "CO",
      zip: "80301",
      email: "admin@example.com",
      password: "password_admin",
      role: 2)

    visit "/login"
    fill_in :Email, with: admin.email
    fill_in :Password, with: admin.password
    click_button "Login"

    visit "/admin/users/#{user1.id}"

    expect(page).to have_content("Name: #{user1.name}")
    expect(page).to have_content("Address: #{user1.address}")
    expect(page).to have_content("City: #{user1.city}")
    expect(page).to have_content("State: #{user1.state}")
    expect(page).to have_content("Zip: #{user1.zip}")
    expect(page).to have_content("Email: #{user1.email}")
    expect(page).to_not have_content(user1.password)
    expect(page).to_not have_link("Orders for #{user1.name}")
    expect(page).to_not have_link("Edit Password")
    expect(page).to_not have_link("Edit My Profile")

    visit "/admin/users/#{user2.id}"

    expect(page).to have_content("Name: #{user2.name}")
    expect(page).to have_content("Address: #{user2.address}")
    expect(page).to have_content("City: #{user2.city}")
    expect(page).to have_content("State: #{user2.state}")
    expect(page).to have_content("Zip: #{user2.zip}")
    expect(page).to have_content("Email: #{user2.email}")
    expect(page).to_not have_content(user2.password)
    expect(page).to have_link("Orders for #{user2.name}")
    expect(page).to_not have_link("Edit Password")
    expect(page).to_not have_link("Edit My Profile")

    click_link "Orders for #{user2.name}"

    expect(current_path).to eq("/admin/users/#{user2.id}/orders")

    within("#order-#{order1.id}") do
      expect(page).to have_content("Order - #{order1.id}")
      expect(page).to have_content("Date Placed: #{order1.created_at}")
      expect(page).to have_content("Date Last Updated: #{order1.updated_at}")
      expect(page).to have_content("Status: #{order1.status}")
      expect(page).to have_content("Item Quantity: #{order1.total_item_quantity}")
      expect(page).to have_content("Grand Total: #{order1.grandtotal}")
    end
    within("#order-#{order2.id}") do
      expect(page).to have_content("Order - #{order2.id}")
      expect(page).to have_content("Date Placed: #{order2.created_at}")
      expect(page).to have_content("Date Last Updated: #{order2.updated_at}")
      expect(page).to have_content("Status: #{order2.status}")
      expect(page).to have_content("Item Quantity: #{order2.total_item_quantity}")
      expect(page).to have_content("Grand Total: #{order2.grandtotal}")
    end
  end
end
