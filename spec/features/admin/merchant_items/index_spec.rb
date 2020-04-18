require 'rails_helper'

RSpec.describe "As an admin when I visit a merchants index", type: :feature do
  before(:each) do
    @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @meg.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @meg.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    @admin_user = @meg.users.create!(
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
    fill_in :Email, with: @admin_user.email
    fill_in :Password, with: @admin_user.password
    click_button "Login"
  end

  it "i see a link to all their items" do
    visit "/admin/merchants/#{@meg.id}"

    click_link("All #{@meg.name} Items")

    expect(current_path).to eq("/admin/merchants/#{@meg.id}/items")

    expect(page).to have_content(@tire.name)
    expect(page).to have_content(@pull_toy.name)
    expect(page).to have_content(@dog_bone.name)
  end

  it "I can click a link and see all of their items info" do
    visit "/admin/merchants/#{@meg.id}/items"
    within "#item-#{@tire.id}" do
      expect(page).to have_content(@tire.name)
      expect(page).to have_content(@tire.description)
      expect(page).to have_content(@tire.price)
      expect(page).to have_content('Active')
      expect(page).to have_content(@tire.inventory)
      expect(page).to have_css("img[src*='#{@tire.image}']")
    end
    within "#item-#{@pull_toy.id}" do
      expect(page).to have_content(@pull_toy.name)
      expect(page).to have_content(@pull_toy.description)
      expect(page).to have_content(@pull_toy.price)
      expect(page).to have_content('Active')
      expect(page).to have_content(@pull_toy.inventory)
      expect(page).to have_css("img[src*='#{@pull_toy.image}']")
    end

    within "#item-#{@dog_bone.id}" do
      expect(page).to have_content(@dog_bone.name)
      expect(page).to have_content(@dog_bone.description)
      expect(page).to have_content(@dog_bone.price)
      expect(page).to have_content('Inactive')
      expect(page).to have_content(@dog_bone.inventory)
      expect(page).to have_css("img[src*='#{@dog_bone.image}']")
    end
  end

  it "I can visit their items index and each item has a button to deactivate active items next to active items" do
    visit "/admin/merchants/#{@meg.id}/items"
    
    within "#item-#{@tire.id}" do
      expect(page).to have_button('Deactivate')
    end
    within "#item-#{@pull_toy.id}" do
     expect(page).to have_button('Deactivate')
    end

    within "#item-#{@dog_bone.id}" do
      expect(page).to_not have_button('Deactivate')
    end
  end

  it "I can visit their items index and click the deactivate button, and i see that item is inactive and a flash message telling me it is inactive" do
    visit "/admin/merchants/#{@meg.id}/items"
    
    within "#item-#{@tire.id}" do
      click_button('Deactivate')
    end

    expect(page).to have_current_path("/admin/merchants/#{@meg.id}/items")
    expect(page).to have_content("#{@tire.name} is no longer for sale!")

    within "#item-#{@tire.id}" do
      expect(page).to have_content('Inactive')
    end
  end

  it "I can visit their items index and each inactive item has a button to activate" do
    visit "/admin/merchants/#{@meg.id}/items"
    within "#item-#{@tire.id}" do
      expect(page).to_not have_button('Activate')
    end
    within "#item-#{@pull_toy.id}" do
    expect(page).to_not have_button('Activate')
    end

    within "#item-#{@dog_bone.id}" do
      expect(page).to have_button('Activate')
    end
  end

  it "I can visit their items index and can click the activate button, and i see that item is active and a flash message telling me it is active" do
    visit "/admin/merchants/#{@meg.id}/items"
    within "#item-#{@tire.id}" do
      click_button('Deactivate')
    end
    
    expect(page).to have_current_path("/admin/merchants/#{@meg.id}/items")
    expect(page).to have_content("#{@tire.name} is no longer for sale!")

    within "#item-#{@tire.id}" do
      click_button('Activate')
    end

    expect(page).to have_current_path("/admin/merchants/#{@meg.id}/items")
    expect(page).to have_content("#{@tire.name} is now for sale!")

    within "#item-#{@tire.id}" do
      expect(page).to have_content("Active")
    end
  end
end
