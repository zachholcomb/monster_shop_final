require 'rails_helper'

RSpec.describe "As a an admin" do
  describe "After visiting a merchants show page and clicking on updating that merchant" do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 11234)
      @user_admin = User.create!(name: "Jordan Sewell", address:"321 Fake St.", city: "Arvada", state: "CO", zip: "80301", email: "chunky_admin@example.com", password: "123password", role: 2)
        visit "/login"
        fill_in :Email, with: @user_admin.email
        fill_in :Password, with: @user_admin.password
        click_button "Login"
    end

    it 'I can see prepopulated info on that user in the edit form' do
      visit "/admin/merchants/#{@bike_shop.id}"
      click_on "Update Merchant"

      expect(page).to have_link(@bike_shop.name)
      expect(find_field('Name').value).to eq "Brian's Bike Shop"
      expect(find_field('Address').value).to eq '123 Bike Rd.'
      expect(find_field('City').value).to eq 'Richmond'
      expect(find_field('State').value).to eq 'VA'
      expect(find_field('Zip').value).to eq "11234"
    end

    it 'I can edit merchant info by filling in the form and clicking submit' do
      visit "/admin/merchants/#{@bike_shop.id}"
      click_on "Update Merchant"

      fill_in 'Name', with: "Brian's Super Cool Bike Shop"
      fill_in 'Address', with: "1234 New Bike Rd."
      fill_in 'City', with: "Denver"
      fill_in 'State', with: "CO"
      fill_in 'Zip', with: 80204

      click_button "Update Merchant"

      expect(current_path).to eq("/admin/merchants/#{@bike_shop.id}")
      expect(page).to have_content("Brian's Super Cool Bike Shop")
      expect(page).to have_content("1234 New Bike Rd.\nDenver, CO 80204")
    end

    it 'I see a flash message if i dont fully complete form' do
      visit "/admin/merchants/#{@bike_shop.id}"
      click_on "Update Merchant"

      fill_in 'Name', with: ""
      fill_in 'Address', with: "1234 New Bike Rd."
      fill_in 'City', with: ""
      fill_in 'State', with: "CO"
      fill_in 'Zip', with: 80204

      click_button "Update Merchant"

      expect(page).to have_content("Name can't be blank and City can't be blank")
      expect(page).to have_button("Update Merchant")
    end
  end
end