require 'rails_helper'

RSpec.describe "As an admin,", type: :feature do 
  describe "when I visit the admin's merchant index page ('/admin/merchants')" do 
    before :each do 
      @admin = User.create!(name: "Jordan Sewell", address:"321 Fake St.", city: "Arvada", state: "CO", zip: "80301", email: "chunky_admin@example.com", password: "123password", role: 2)
      @dog_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210, enabled?: true)
      @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203, enabled?: true)
      @candy_shop = Merchant.create(name: "50 Cents Candy Shop", address: '512 Electric Avenue', city: 'Silverthorne', state: 'CO', zip: 81103, enabled?: false)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

      @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      @dog_ball = @dog_shop.items.create(name: "Dog Ball", description: "Awesome dog ball!", price: 5, image: "https://img.chewy.com/is/image/catalog/59155_MAIN._AC_SL1500_V1518033665_.jpg", inventory: 20)
      @dog_bowl = @dog_shop.items.create(name: "Dog Bowl", description: "Great dog bowl!", price: 7, image: "https://www.talltailsdog.com/pub/media/catalog/product/cache/a0f79b354624f8eb0e90cc12a21406d2/u/n/untitled-6.jpg", inventory: 32)
    end 

    it "then I click on a merchant's name" do
      visit admin_merchants_path 

      click_on @bike_shop.name

      expect(current_path).to eq("/admin/merchants/#{@bike_shop.id}")
      expect(page).to have_content(@bike_shop.name)
      expect(page).to have_content(@bike_shop.address)
      expect(page).to have_content(@bike_shop.city)
      expect(page).to have_content(@bike_shop.item_count)
      expect(page).to have_content(@bike_shop.city)
    end
  end 
end