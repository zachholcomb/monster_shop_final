require 'rails_helper'

RSpec.describe "As a merchant employee when I visit my items page" do
  it "I see a button to delete next to items that have never been ordered" do
    meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    pull_toy = meg.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = meg.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    user_employee = meg.users.create!(name: "Steve", address:"123 Main St.", city: "Fort Collins", state: "GA", zip: "66666", email: "chunky_lover@example.com", password: "123password", role: 1)

    user = User.create!(name: "Steve", address:"123 Main St.", city: "Fort Collins", state: "GA", zip: "66666", email: "new_user@example.com", password: "123password")
    order1 = Order.create(name: 'Steve', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', user: user)
    ItemOrder.create!(item: tire, order: order1, price: tire.price, quantity: 5)
    visit "/login"
    fill_in :Email, with: user_employee.email
    fill_in :Password, with: user_employee.password
    click_button "Login"

    visit "/merchant/items"

    within "#item-#{tire.id}" do
      expect(page).to_not have_button('Delete')
    end

    within "#item-#{pull_toy.id}" do
      expect(page).to have_button('Delete')
    end

    within "#item-#{dog_bone.id}" do
      expect(page).to have_button('Delete') 
    end
  end

  it "I click the delete button next to an item that has never been ordered and I am returned to my items page and see a flash message indicating it was deleted" do
    meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    pull_toy = meg.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = meg.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    user_employee = meg.users.create!(name: "Steve", address:"123 Main St.", city: "Fort Collins", state: "GA", zip: "66666", email: "chunky_lover@example.com", password: "123password", role: 1)

    user = User.create!(name: "Steve", address:"123 Main St.", city: "Fort Collins", state: "GA", zip: "66666", email: "new_user@example.com", password: "123password")
    order1 = Order.create(name: 'Steve', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', user: user)
    ItemOrder.create!(item: tire, order: order1, price: tire.price, quantity: 5)
    visit "/login"
    fill_in :Email, with: user_employee.email
    fill_in :Password, with: user_employee.password
    click_button "Login"

    visit "/merchant/items"

    within "#item-#{pull_toy.id}" do
      click_button('Delete')
    end
    expect(page).to have_current_path('/merchant/items')
    expect(page).to_not have_css("#item-#{pull_toy.id}")
    expect(page).to have_content("#{pull_toy.name} was successfully deleted")
  end
end