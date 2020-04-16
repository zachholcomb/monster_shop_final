require 'rails_helper'

RSpec.describe "As a visitor,", type: :feature do 
  it "I can see a welcome page." do 
    visit "/"
    expect(page).to have_content("WELCOME TO MONSTER SHOP")
  end
end