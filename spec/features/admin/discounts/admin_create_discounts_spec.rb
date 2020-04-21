require 'rails_helper'

RSpec.describe "Discounts create page" do
  before(:each) do
    @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @meg.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @meg.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    @discount1 = @meg.discounts.create!(name: "Flash Sale", percentage: 10, item_amount: 20)
    @discount2 = @meg.discounts.create!(name: "Fifty Percent Off 50 items", percentage: 50, item_amount: 50)
    @user = @meg.users.create!(
      name: "Steve",
      address:"123 Main St.",
      city: "Fort Collins",
      state: "GA",
      zip: "66666",
      email: "chunky_lover@example.com",
      password: "123password",
      role: 2
    )

    visit "/login"
    fill_in :Email, with: @user.email
    fill_in :Password, with: @user.password
    click_button "Login"
  end

  it "can create new discounts and shows a message letting user know discount was created" do
    visit "/admin/merchants/#{@meg.id}/discounts"
    click_link "Create New Discount"
    fill_in :name, with: "Ninety Percent off 100 items or more!"
    fill_in :percentage, with: "90"
    fill_in :item_amount, with: "100"
    click_button 'Create Discount'
    expect(page).to have_current_path("/admin/merchants/#{@meg.id}/discounts")
    expect(page).to have_content("Discount was successfully created!")
    expect(page).to have_content("Ninety Percent off 100 items or more!")
  end

  it "cant create discounts without the required information" do
    visit "/admin/merchants/#{@meg.id}/discounts"
    click_link "Create New Discount"
    fill_in :name, with: ""
    fill_in :percentage, with: "90"
    fill_in :item_amount, with: "1"
    click_button 'Create Discount'
    expect(page).to have_content("Name can't be blank and Item amount must be greater than 1")

  end
end
