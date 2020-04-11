require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it "all items, pictures, and merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_css("img[src*='#{@tire.image}']")
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
      expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      find(:xpath, "//a/img[@alt='Tug toy dog pull 9010 2 800x800']/..").click
      expect(current_path).to eq("/items/#{@pull_toy.id}")
    end


    it "I can see a list of all of the active items "do


      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

        expect(page).to have_no_link(@dog_bone.name)
        expect(page).to have_no_content(@dog_bone.description)
        expect(page).to have_no_content("Price: $#{@dog_bone.price}")
        expect(page).to have_no_content("Inactive")
        expect(page).to have_no_content("Inventory: #{@dog_bone.inventory}")
        expect(page).to have_no_css("img[src*='#{@dog_bone.image}']")

    end

    it "I see most and least popular items listed, plus the quantity bought" do
      order1 = Order.create(name: 'Steve',
                            address: '555 Free St.',
                            city: 'Plano',
                            state: 'TX',
                            zip: '88992')

      order2 = Order.create(name: 'Steve',
                        address: '555 Free St.',
                        city: 'Plano',
                        state: 'TX',
                        zip: '88992')
      tire2 = @meg.items.create(name: "Goodyear", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)
      dog_bowl = @brian.items.create(name: "Dog Bowl", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      dog_ball = @brian.items.create(name: "Dog Ball", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      dog_leash = @brian.items.create(name: "Dog Leash", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      
      user = User.create!(name: "Steve", address:"123 Main St.", city: "Fort Collins", state: "GA", zip: "66666", email: "chunky_lover@example.com", password: "123password")
      order1 = Order.create(name: 'Steve', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', user: user)
      order2 = Order.create(name: 'Steve', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', user: user)
      ItemOrder.create!(item: @tire, order: order1, price: @tire.price, quantity: 5)
      ItemOrder.create!(item: @pull_toy, order: order2, price: @pull_toy.price, quantity: 7)
      ItemOrder.create!(item: dog_bone, order: order1, price: dog_bone.price, quantity: 4)
      ItemOrder.create!(item: @tire, order: order2, price: @tire.price, quantity: 5)
      ItemOrder.create!(item: dog_ball, order: order2, price: dog_ball.price, quantity: 3)
      ItemOrder.create!(item: dog_bowl, order: order2, price: dog_bowl.price, quantity: 2)
      ItemOrder.create!(item: tire2, order: order1, price: tire2.price, quantity: 1)

      visit "/items"
      within '#item-stats' do
        within "#most-popular" do
          expect(page.all('li')[0]).to have_content('Gatorskins: 10')
          expect(page.all('li')[1]).to have_content('Pull Toy: 7')
          expect(page.all('li')[2]).to have_content('Dog Bone: 4')
          expect(page.all('li')[3]).to have_content('Dog Ball: 3')
          expect(page.all('li')[4]).to have_content('Dog Bowl: 2')
        end

        within "#least-popular" do
          expect(page.all('li')[0]).to have_content('Dog Leash: 0')
          expect(page.all('li')[1]).to have_content('Goodyear: 1')
          expect(page.all('li')[2]).to have_content('Dog Bowl: 2')
          expect(page.all('li')[3]).to have_content('Dog Ball: 3')
          expect(page.all('li')[4]).to have_content('Dog Bone: 4')
        end
      end
    end
  end
end
