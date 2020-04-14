require 'rails_helper'

RSpec.describe "as a merchant employee, when i visit my merchant dashboard", type: :feature do
  it "i see a link to my items and when i click it i go to /merchant/items" do

    meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    pull_toy = meg.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = meg.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    user = meg.users.create!(
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
    fill_in :Email, with: user.email
    fill_in :Password, with: user.password
    click_button "Login"

    expect(current_path).to eq("/merchant/dashboard")

    click_link("Merchant Items")

    expect(current_path).to eq("/merchant/items")

    expect(page).to have_content(tire.name)
    expect(page).to have_content(pull_toy.name)
    expect(page).to have_content(dog_bone.name)
  end

  it "I see all of my items info" do
    meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    pull_toy = meg.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = meg.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    user = meg.users.create!(
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
    fill_in :Email, with: user.email
    fill_in :Password, with: user.password
    click_button "Login"

    visit "/merchant/items"
    
    within "#item-#{tire.id}" do
      expect(page).to have_content(tire.name)
      expect(page).to have_content(tire.description)
      expect(page).to have_content(tire.price)
      expect(page).to have_content('Active')
      expect(page).to have_content(tire.inventory)
      expect(page).to have_css("img[src*='#{tire.image}']")
    end
    within "#item-#{pull_toy.id}" do
      expect(page).to have_content(pull_toy.name)
      expect(page).to have_content(pull_toy.description)
      expect(page).to have_content(pull_toy.price)
      expect(page).to have_content('Active')
      expect(page).to have_content(pull_toy.inventory)
      expect(page).to have_css("img[src*='#{pull_toy.image}']")
    end

    within "#item-#{dog_bone.id}" do
      expect(page).to have_content(dog_bone.name)
      expect(page).to have_content(dog_bone.description)
      expect(page).to have_content(dog_bone.price)
      expect(page).to have_content('Inactive')
      expect(page).to have_content(dog_bone.inventory)
      expect(page).to have_css("img[src*='#{dog_bone.image}']")
    end
  end

  it "has a button to deactivate active items next to active items" do
    meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    pull_toy = meg.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = meg.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    user = meg.users.create!(
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
    fill_in :Email, with: user.email
    fill_in :Password, with: user.password
    click_button "Login"

    visit "/merchant/items"
    
    within "#item-#{tire.id}" do
      expect(page).to have_button('Deactivate')
    end
    within "#item-#{pull_toy.id}" do
     expect(page).to have_button('Deactivate')
    end

    within "#item-#{dog_bone.id}" do
      expect(page).to_not have_button('Deactivate')
    end
  end

  it "and click the deactivate button, and i see that item is inactive and a flash message telling me it is inactive" do
    meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    pull_toy = meg.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = meg.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    user = meg.users.create!(
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
    fill_in :Email, with: user.email
    fill_in :Password, with: user.password
    click_button "Login"

    visit "/merchant/items"
    
    within "#item-#{tire.id}" do
      click_button('Deactivate')
    end

    expect(page).to have_current_path('/merchant/items')
    expect(page).to have_content("#{tire.name} is no longer for sale!")

    within "#item-#{tire.id}" do
      expect(page).to have_content('Inactive')
    end
  end

    it "has a button to activate inactive items next to inactive items" do
    meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    pull_toy = meg.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = meg.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    user = meg.users.create!(
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
    fill_in :Email, with: user.email
    fill_in :Password, with: user.password
    click_button "Login"

    visit "/merchant/items"
    
    within "#item-#{tire.id}" do
      expect(page).to_not have_button('Activate')
    end
    within "#item-#{pull_toy.id}" do
     expect(page).to_not have_button('Activate')
    end

    within "#item-#{dog_bone.id}" do
      expect(page).to have_button('Activate')
    end
  end

  it "and click the activate button, and i see that item is active and a flash message telling me it is active" do
    meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    pull_toy = meg.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = meg.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    user = meg.users.create!(
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
    fill_in :Email, with: user.email
    fill_in :Password, with: user.password
    click_button "Login"

    visit "/merchant/items"
    
    within "#item-#{tire.id}" do
      click_button('Deactivate')
    end
    
    expect(page).to have_current_path('/merchant/items')
    expect(page).to have_content("#{tire.name} is no longer for sale!")

    within "#item-#{tire.id}" do
      click_button('Activate')
    end

    expect(page).to have_current_path('/merchant/items')
    expect(page).to have_content("#{tire.name} is now for sale!")

    within "#item-#{tire.id}" do
      expect(page).to have_content("Active")
    end
  end
end
