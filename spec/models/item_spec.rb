require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'associations' do
    it { should belong_to(:merchant) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price) }
  end

  describe 'class methods' do
    describe '::fetch_requested_items' do
      it 'returns items with the requested parameters appropriately' do
        # the page parameter (2nd parameter here) is subtracted by 1 and multiplied by 20 before arriving as argument in this method
        merchant = create(:merchant)
        create_list(:item, 50, merchant: merchant)

        expect(Item.fetch_requested_items(100, 0).count).to eq(50)
        expect(Item.fetch_requested_items(50, 60).count).to eq(0)
        expect(Item.fetch_requested_items(25, 20).count).to eq(25)
        expect(Item.fetch_requested_items(50, 0).count).to eq(50)
      end
    end

    describe '#fetch_item' do
      it 'returns the requested item' do
        merchant = create(:merchant)
        item = create(:item, merchant: merchant)
        expect(Item.fetch_item(item)).to eq(item)
      end
    end
  end
end
