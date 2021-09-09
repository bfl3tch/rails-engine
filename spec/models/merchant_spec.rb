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

    describe '::fetch_merchant_items' do
      it 'returns all items belonging to the merchant' do
        merchant = create(:merchant)
        item = create(:item, merchant: merchant)
        expect(Merchant.fetch_merchant_items(merchant)).to eq([item])
      end

      it 'doesnt return items from another merchant' do
        merchant1 = create(:merchant)
        merchant2 = create(:merchant)

        item1 = create(:item, merchant: merchant1)
        item2 = create(:item, merchant: merchant2)
        item3 = create(:item, merchant: merchant1)

        expect(Merchant.fetch_merchant_items(merchant1)).not_to eq([item2])
        expect(Merchant.fetch_merchant_items(merchant2)).not_to eq([item1, item3])
      end
    end

    describe '::find_by_name' do
      it 'returns all merchants with matches to that name' do
        merchant1 = create(:merchant, name: 'Joe')
        merchant2 = create(:merchant, name: 'joe')
        merchant3 = create(:merchant, name: 'Joel')
        merchant4 = create(:merchant, name: 'joelneville')
        merchant5 = create(:merchant, name: 'bob')

        expect(Merchant.find_by_name('joe')).to eq([merchant1, merchant3, merchant2, merchant4])
      end

      it 'doesnt return items from another merchant' do
        merchant1 = create(:merchant)
        merchant2 = create(:merchant)

        item1 = create(:item, merchant: merchant1)
        item2 = create(:item, merchant: merchant2)
        item3 = create(:item, merchant: merchant1)

        expect(Merchant.fetch_merchant_items(merchant1)).not_to eq([item2])
        expect(Merchant.fetch_merchant_items(merchant2)).not_to eq([item1, item3])
      end
    end
  end
end
