require 'rails_helper'

RSpec.describe "As a merchant employee, when I visit my items page" do
  before(:each) do
    @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @meg.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @meg.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    @user_admin = User.create!(name: "Steve", address:"123 Main St.", city: "Fort Collins", state: "GA", zip: "66666", email: "chunky_lover@example.com", password: "123password", role: 2)

    user = User.create!(name: "Steve", address:"123 Main St.", city: "Fort Collins", state: "GA", zip: "66666", email: "new_user@example.com", password: "123password")
    @order1 = Order.create!(name: 'Steve', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', user: user)
    ItemOrder.create!(item: @tire, order: @order1, price: @tire.price, quantity: 5)
    visit "/login"
    fill_in :Email, with: @user_admin.email
    fill_in :Password, with: @user_admin.password
    click_button "Login"
  end

  it 'I see a button to edit an item next to all items' do
    visit "/admin/merchants/#{@meg.id}/items"

    within "#item-#{@tire.id}" do
      expect(page).to have_button('Edit')
    end

    within "#item-#{@pull_toy.id}" do
      expect(page).to have_button('Edit')
    end

    within "#item-#{@dog_bone.id}" do
      expect(page).to have_button('Edit') 
    end
  end
  
  it 'When I click edit I am taken to an edit form that is prepopulated with the item info' do
    visit "/admin/merchants/#{@meg.id}/items"

    within "#item-#{@tire.id}" do
      click_button 'Edit'
    end

    expect(find_field(:Description).value).to have_content(@tire.description)
    expect(find_field(:Name).value).to have_content(@tire.name)
    expect(find_field(:Price).value).to have_content(@tire.price)
    expect(find_field(:Image).value).to have_content(@tire.image)
    expect(find_field(:Inventory).value).to have_content(@tire.inventory)
  end
 
  it 'When I click Submit Changes, I am taken back to the item index page where I see the changes' do
    visit "/admin/merchants/#{@meg.id}/items"

    within "#item-#{@tire.id}" do
      click_button 'Edit'
    end

    fill_in :Name, with: "Bike Chain"
    fill_in :Description, with: "Gets you going!"
    fill_in :Image, with: ""
    fill_in :Price, with: 30000
    fill_in :Inventory, with: 900
    click_button 'Submit Changes'

    expect(current_path).to eq("/admin/merchants/#{@meg.id}/items")

    within "#item-#{@tire.id}" do
      expect(page).to have_content('Bike Chain')
      expect(page).to have_content('Gets you going!')
      expect(page).to have_content("$30,000.00")
      expect(page).to have_content(900)
    end
  end

  it 'when I leave out name, or description or the price and inventory is not greater than 0, I see a message telling me so' do
    visit "/admin/merchants/#{@meg.id}/items"

    within "#item-#{@tire.id}" do
      click_button 'Edit'
    end

    fill_in :Name, with: "Chain"
    fill_in :Description, with: ""
    fill_in :Price, with: 0
    fill_in :Inventory, with: -1
    click_button 'Submit Changes'

    expect(find_field(:Description).value).to have_content(@tire.description)
    expect(find_field(:Name).value).to have_content(@tire.name)
    expect(find_field(:Price).value).to have_content(@tire.price)
    expect(find_field(:Image).value).to have_content(@tire.image)
    expect(find_field(:Inventory).value).to have_content(@tire.inventory)

    expect(page).to have_content("Description can't be blank, Price must be greater than 0, and Inventory must be greater than or equal to 0")
  end
end