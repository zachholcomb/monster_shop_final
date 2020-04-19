require 'rails_helper'

RSpec.describe 'Merchant discount edit page' do
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
      role: 1
    )

    visit "/login"
    fill_in :Email, with: @user.email
    fill_in :Password, with: @user.password
    click_button "Login"
  end

  it "can edit a discount" do
    visit "/merchant/discounts/#{@discount1.id}/edit"
    expect(find_field(:name).value).to have_content(@discount1.name)
    expect(find_field(:percentage).value).to have_content(10)
    expect(find_field(:item_amount).value).to have_content(20)
    
    fill_in :name, with: "Buy More and Save!"
    fill_in :percentage, with: 95
    fill_in :item_amount, with: 110
    click_button 'Submit Changes'
    expect(page).to have_current_path('/merchant/dashboard')
    expect(page).to have_content("Discount successfully updated")
    within "#discount-#{@discount1.id}" do
      expect(page).to have_content('Buy More and Save!')
    end
  end

  it "can't edit with wrong parameters" do
    visit "/merchant/discounts/#{@discount1.id}/edit"
    fill_in :name, with: ""
    fill_in :percentage, with: 0
    fill_in :item_amount, with: "ad"
    click_button 'Submit Changes'
    expect(page).to have_current_path("/merchant/discounts/#{@discount1.id}/edit")
    
    expect(find_field(:name).value).to have_content(@discount1.name)
    expect(find_field(:percentage).value).to have_content(10)
    expect(find_field(:item_amount).value).to have_content(20)
    expect(page).to have_content("Name can't be blank, Percentage must be greater than 0, and Item amount is not a number")
  end
end