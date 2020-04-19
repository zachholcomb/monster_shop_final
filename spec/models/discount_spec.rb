require 'rails_helper'

RSpec.describe Discount do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:percentage) }
    it { should validate_presence_of(:item_amount) }
    it { should validate_numericality_of(:percentage).is_greater_than(0) }
    it { should validate_numericality_of(:item_amount).is_greater_than(1) }
  end

  describe "relationships" do
   it { should belong_to(:merchant) } 
  end
end