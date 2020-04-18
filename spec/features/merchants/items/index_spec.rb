require 'rails_helper'

RSpec.describe 'Merchants items index page' do
  before(:each) do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @meg.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
  end

  it "displays a list of all merchants items" do
    visit "/merchants/#{@meg.id}/items"
    expect(page).to have_content(@meg.name)
    expect(page).to have_content(@tire.name)
    expect(page).to have_content(@pull_toy.name)
  end
end