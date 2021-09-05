require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'associations' do
    it { should have_many(:items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'class methods' do
    describe '::fetch_requested_merchants' do
      it 'returns merchants with the requested parameters appropriately' do
        # the page parameter (2nd parameter here) is subtracted by 1 and multiplied by 20 before arriving as argument in this method
        create_list(:merchant, 50)

        expect(Merchant.fetch_requested_merchants(100, 0).count).to eq(50)
        expect(Merchant.fetch_requested_merchants(50, 60).count).to eq(0)
        expect(Merchant.fetch_requested_merchants(25, 20).count).to eq(25)
        expect(Merchant.fetch_requested_merchants(50, 0).count).to eq(50)
      end
    end
  end

  describe 'instance methods' do
    describe '#fetch_merchant_items' do
      it 'returns all items belonging to the merchant' do
        merchant = create(:merchant)
        item = create(:item, merchant: merchant)
        expect(merchant.fetch_merchant_items).to eq(item)
      end

      it 'doesnt return items from another merchant' do
        merchant1 = create(:merchant)
        merchant2 = create(:merchant)

        item1 = create(:item, merchant: merchant1)
        item2 = create(:item, merchant: merchant2)

        expect(merchant1.fetch_merchant_items).not_to eq(item2)
        expect(merchant2.fetch_merchant_items).not_to eq(item1)
      end

    end
  end
end
