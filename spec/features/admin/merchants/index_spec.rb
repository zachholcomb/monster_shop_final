require 'rails_helper'

RSpec.describe "As an admin,", type: :feature do 
  describe "when I visit the admin's merchant index page ('/admin/merchants')" do 
    before :each do 
      @admin = User.create!(name: "Jordan Sewell", address:"321 Fake St.", city: "Arvada", state: "CO", zip: "80301", email: "chunky_admin@example.com", password: "123password", role: 2)
      @dog_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210, enabled?: true)
      @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203, enabled?: true)
      @candy_shop = Merchant.create(name: "50 Cent's Candy Shop", address: '512 Electric Avenue', city: 'Silverthorne', state: 'CO', zip: 81103, enabled?: false)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

      @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      @dog_ball = @dog_shop.items.create(name: "Dog Ball", description: "Awesome dog ball!", price: 5, image: "https://img.chewy.com/is/image/catalog/59155_MAIN._AC_SL1500_V1518033665_.jpg", inventory: 20)
      @dog_bowl = @dog_shop.items.create(name: "Dog Bowl", description: "Great dog bowl!", price: 7, image: "https://www.talltailsdog.com/pub/media/catalog/product/cache/a0f79b354624f8eb0e90cc12a21406d2/u/n/untitled-6.jpg", inventory: 32)

      @lollipop = @candy_shop.items.create(name: "Lollipop", description: "Sweet!", price: 13, image: "https://hotlix.com/wp-content/uploads/2018/07/ant-individual-watermelon.jpg", inventory: 8, active?: false)
      @tootsie_roll = @candy_shop.items.create(name: "Tootsie Roll", description: "Brown chocolate log", price: 40, image: "https://upload.wikimedia.org/wikipedia/commons/2/20/Tootsie-Roll-Log-Large.jpg", inventory: 17, active?: false)    
    end 
    
    it "then I see a 'disable' button next to active mechants that, when clicked, returns me to admin merchant index where I see merchant account disabled, flash message, and '/merchants/:id/items show inactive." do 
      visit admin_merchants_path 

      within "#merchant-#{@bike_shop.id}" do 
        expect(page).to have_button("Disable Merchant")
      end
      
      within "#merchant-#{@dog_shop.id}" do 
        expect(page).to have_button("Disable Merchant")
        click_on "Disable Merchant"
      end

      expect(current_path).to eq(admin_merchants_path)
      
      within "#merchant-#{@dog_shop.id}" do 
        expect(page).to_not have_button("Disable Merchant")
      end
      expect(page).to have_content("#{@dog_shop.name} is now disabled.")
      
      visit "/merchants/#{@dog_shop.id}/items"

      within "#item-#{@pull_toy.id}" do 
        expect(page).to have_content("Inactive")
      end

      within "#item-#{@dog_bone.id}" do
        expect(page).to have_content("Inactive") 
      end

      within "#item-#{@dog_ball.id}" do 
        expect(page).to have_content("Inactive")
      end
      
      within "#item-#{@dog_bowl.id}" do 
        expect(page).to have_content("Inactive")
      end
    end 

    it "then I see a 'enable' button next to active mechants that, when clicked, returns me to admin merchant index where I see merchant account enabled, flash message, and '/merchants/:id/items show active." do    
      visit admin_merchants_path 
      
      within "#merchant-#{@candy_shop.id}" do 
        expect(page).to have_button("Enable Merchant")
        click_on "Enable Merchant"
      end

      expect(current_path).to eq(admin_merchants_path)
      
      within "#merchant-#{@candy_shop.id}" do 
        expect(page).to_not have_button("Enable Merchant")
      end
      expect(page).to have_content("#{@candy_shop.name} is now enabled.")
      
      visit "/merchants/#{@candy_shop.id}/items"

      within "#item-#{@lollipop.id}" do 
        expect(page).to have_content("Active")
      end

      within "#item-#{@tootsie_roll.id}" do
        expect(page).to have_content("Active") 
      end
    end 
  end 
end