require 'rails_helper'

RSpec.describe "As a merchant user, when I visit my dashboard" do
  before(:each) do
    @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @meg.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @meg.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)
    @tire2 = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, inventory: 12)
    @pull_toy2 = @meg.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, inventory: 32)
    @dog_bone2 = @meg.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, inventory: 21)
    @discount1 = @meg.discounts.create!(name: "Flash Sale", percentage: 10, item_amount: 5)
    @discount2 = @meg.discounts.create!(name: "Fifty Percent Off 50 items", percentage: 20, item_amount: 10)
    @user = @meg.users.create!(
      name: "Steve",
      address:"123 Main St.",
      city: "Fort Collins",
      state: "GA",
      zip: "66666",
      email: "chunky_lover@example.com",
      password: "123password",
      role: 1
    )

    visit "/login"
    fill_in :Email, with: @user.email
    fill_in :Password, with: @user.password
    click_button "Login"
  end

  it "I see a to do list for items that need my attention" do
    expect(page).to have_current_path("/merchant/dashboard") 
    expect(page).to have_content("** TO DO: **") 
  end

  it "I see a section of the to do list that lists any of my items that are using a default image" do
    visit "/merchant/dashboard"
    within "#to-do-list" do
      expect(page).to have_content("My Items That Need Images")
      expect(page).to have_link(@tire2.name)
      expect(page).to have_link(@pull_toy2.name)
      expect(page).to have_link(@dog_bone2.name)

      click_link @tire2.name
    end

    expect(page).to have_current_path("/merchant/items/#{@tire2.id}/edit")
    expect(find_field(:Image).value).to have_content('https://static.wixstatic.com/media/d8d60b_6ff8d8667db1462492d681839d85054c~mv2.png/v1/fill/w_900,h_900,al_c,q_90/file.jpg')
  end

  it "I see a message saying that no items need their images updated" do
    click_link 'Logout'
    bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    employee = bike_shop.users.create!(
        name: "Steve",
        address:"123 Main St.",
        city: "Fort Collins",
        state: "GA",
        zip: "66666",
        email: "chunky_merchant@example.com",
        password: "123password",
        role: 1
      )
    
    visit "/login"
    fill_in :Email, with: employee.email
    fill_in :Password, with: employee.password
    click_button "Login"
    
    within "#to-do-list" do
      expect(page).to have_content("No images to update!")
    end
  end
end