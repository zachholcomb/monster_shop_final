require 'rails_helper'

RSpec.describe 'As a merchant employee when I visit my items page' do
  it "I see a link to add a new item" do
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
    expect(page).to have_link('Add New Item')
  end

   it "I click a link to add a new item and I am taken to a form to add new item" do
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
    click_link('Add New Item')
    expect(page).to have_current_path('/merchant/items/new')
    expect(page).to have_content('Name:')
    expect(page).to have_content('Description:')
    expect(page).to have_content('Image:')
    expect(page).to have_content('Price:')
    expect(page).to have_content('Inventory:')
  end

  it "I click a link to add a new item and I am taken to a form to add new item" do
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
    click_link('Add New Item')
    expect(page).to have_current_path('/merchant/items/new')
    fill_in :Name, with: "Bike Chain"
    fill_in :Description, with: "It'll grind your gears!"
    fill_in :Image, with: "https://techybeasts.com/wp-content/uploads/2018/04/bike-chain-1.jpg"
    fill_in :Price, with: 90
    fill_in :Inventory, with: 5
    click_button("Create Item")
   
    expect(page).to have_current_path('/merchant/items')
    expect(page).to have_content('Your item was saved!')
    expect(page).to have_content("Bike Chain")
  end

  it "I cannot add an item without a name or description" do
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
    click_link('Add New Item')
    expect(page).to have_current_path('/merchant/items/new')

    fill_in :Name, with: ""
    fill_in :Description, with: ""
    fill_in :Image, with: "https://techybeasts.com/wp-content/uploads/2018/04/bike-chain-1.jpg"
    fill_in :Price, with: 90
    fill_in :Inventory, with: 5
    click_button("Create Item")
   
    expect(page).to have_content("Name can't be blank and Description can't be blank")
  end

  it "I can add an item without an image and it is given a default image" do
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
    click_link('Add New Item')
    expect(page).to have_current_path('/merchant/items/new')
    fill_in :Name, with: "Bike Chain"
    fill_in :Description, with: "It'll grind your gears!"
    fill_in :Price, with: 90
    fill_in :Inventory, with: 5
    click_button("Create Item")
   
    expect(page).to have_current_path('/merchant/items')
  
    expect(page).to have_content('Your item was saved!')
    expect(page).to have_css("img[src*='https://static.wixstatic.com/media/d8d60b_6ff8d8667db1462492d681839d85054c~mv2.png/v1/fill/w_900,h_900,al_c,q_90/file.jpg']")
  end

  it "I can only create items where the price is greater than 0" do
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
    click_link('Add New Item')
    expect(page).to have_current_path('/merchant/items/new')
    fill_in :Name, with: "Bike Chain"
    fill_in :Description, with: "It'll grind your gears!"
    fill_in :Image, with: ""
    fill_in :Price, with: 0
    fill_in :Inventory, with: 5
    click_button("Create Item")
   
    expect(page).to have_content("Price must be greater than 0")
  end

  it "I can only create items where the inventory is greater than 0" do
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
    click_link('Add New Item')
    expect(page).to have_current_path('/merchant/items/new')
    fill_in :Name, with: "Bike Chain"
    fill_in :Description, with: "It'll grind your gears!"
    fill_in :Image, with: ""
    fill_in :Price, with: 100
    fill_in :Inventory, with: 0
    click_button("Create Item")
   
    expect(page).to have_content("Inventory must be greater than 0")
  end
end