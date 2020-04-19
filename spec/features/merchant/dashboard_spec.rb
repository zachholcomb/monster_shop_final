require 'rails_helper'

RSpec.describe "as a merchant employee, when i visit my merchant dashboard", type: :feature do
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

  it "i see the name and full address of the merchant i work for" do
    expect(current_path).to eq("/merchant/dashboard")
    expect(page).to have_content(@meg.name)
    expect(page).to have_content(@meg.address)
    expect(page).to have_content("#{@meg.city}, #{@meg.state} #{@meg.zip}")
  end

  it "I see a list of all my discounts for my shop" do
    visit "/merchant/dashboard"

    within "#merchant-discounts" do
      expect(page).to have_content(@discount1.name)
      expect(page).to have_content(@discount2.name)
    end
  end

  it "All my discounts are a link to that discounts show page and I can click the link and it takes me to my discounts show page" do
    visit "/merchant/dashboard"
    within "#merchant-discounts" do
      expect(page).to have_link(@discount1.name)
      click_link @discount1.name
    end
    expect(page).to have_current_path("/merchant/discounts/#{@discount1.id}")

    visit "/merchant/dashboard"

    within "#merchant-discounts" do
      expect(page).to have_link(@discount2.name)
      click_link @discount2.name
    end
    expect(page).to have_current_path("/merchant/discounts/#{@discount2.id}")
  end

  it "I see a link to my discounts index page and when I click it takes me to my discount index" do
    visit "/merchant/dashboard"
    within "#merchant-discounts" do
      expect(page).to have_link('My Discounts')
      click_link 'My Discounts'
    end
    expect(page).to have_current_path("/merchant/discounts")
  end
end
