require 'rails_helper'

RSpec.describe "As a user when I add enough of one item to my cart" do
  before(:each) do
    @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @meg.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @meg.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)
    @discount1 = @meg.discounts.create!(name: "Flash Sale", percentage: 10, item_amount: 5)
    @discount2 = @meg.discounts.create!(name: "Fifty Percent Off 50 items", percentage: 25, item_amount: 10)
    @user = User.create!(
      name: "Steve",
      address:"123 Main St.",
      city: "Fort Collins",
      state: "GA",
      zip: "66666",
      email: "chunky_lover@example.com",
      password: "123password",
      role: 0
    )
    visit "/login"
    fill_in :Email, with: @user.email
    fill_in :Password, with: @user.password
    click_button "Login"

    visit "/items/#{@tire.id}"
    click_on "Add To Cart"

    visit "/cart"

    within "#item-quantity-#{@tire.id}" do
      click_on "Increase Quantity"
      click_on "Increase Quantity"
      click_on "Increase Quantity"
      click_on "Increase Quantity"
    end
  end

  it "I see a discount applied to that item" do
    visit "/cart"
    
    within "#item-quantity-#{@tire.id}" do
      expect(page).to have_content("5")
      expect(page).to have_content "$450.00"
    end 
  end

  it "I see a discount applied to that item and not my other items" do
    visit "/items/#{@dog_bone.id}"
    click_on "Add To Cart"

    visit "/cart"

    expect(page).to have_content("$90.00")      
     within "#item-quantity-#{@tire.id}" do
      expect(page).to have_content("5")
      expect(page).to have_content "$450.00"
    end 

    within "#item-quantity-#{@dog_bone.id}" do
      expect(page).to have_content("1")
      expect(page).to have_content "$21.00"
    end 
  end
  

  it "I see the discount applied with the highest percentage off as increase my items quantity" do
    visit "/cart"
    within "#item-quantity-#{@tire.id}" do
      5.times do
        click_on "Increase Quantity"
      end
    end
    expect(page).to have_content("$75.00")
    within "#item-quantity-#{@tire.id}" do
      expect(page).to have_content("5")
      expect(page).to have_content "$750.00"
    end 
  end 

  it "I see the name of the discount that has been applied to my order" do
    visit "/cart"

    within "#item-quantity-#{@tire.id}" do
      expect(page).to have_content("#{@tire.name} qualifies for #{@discount1.name}")

      5.times do
        click_on "Increase Quantity"
      end

      expect(page).to have_content(@discount2.name)
    end 
  end 

  it "I see that I have no discounts applied if my item doesn't qualify for any discounts" do
    visit "/items/#{@pull_toy.id}"
    click_on "Add To Cart"

    visit "/cart"

    within "#item-#{@pull_toy.id}" do
      expect(page).to have_content("No discounts applied, order more and save!")
    end
  end
end