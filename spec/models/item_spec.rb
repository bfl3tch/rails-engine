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

    describe '::case_sensitive_search' do
      it 'searches case insenitively through items to get the first best response' do
        merchant = create(:merchant)
        item1 = create(:item, name: "basket", merchant: merchant)
        item2 = create(:item, name: "base", merchant: merchant)
        item3 = create(:item, name: "footBALL", merchant: merchant)
        item4 = create(:item, name: "tennis bAlL", merchant: merchant)

        expect(Item.case_insensitive_search("ball")).to eq(item3)
      end

      it 'searches through descriptions as well as names' do
        merchant = create(:merchant)
        item1 = create(:item, name: "basket", merchant: merchant)
        item2 = create(:item, name: "baseball", merchant: merchant)
        item3 = create(:item, name: "desk", description: 'wish this was a ballerina', merchant: merchant)
        item4 = create(:item, name: "Beer", description: 'wish this was a bALL of fun', merchant: merchant)

        expect(Item.case_insensitive_search("bAlL")).to eq(item2)
      end

      it 'orders the items alphabetically that match the search results' do
        merchant = create(:merchant)
        item1 = create(:item, name: "Compasket", merchant: merchant)
        item2 = create(:item, name: "Basket", merchant: merchant)
        item3 = create(:item, name: "Fasket", description: 'wish this was a ballerina', merchant: merchant)
        item4 = create(:item, name: "Dasket", description: 'wish this was a bALL of fun', merchant: merchant)
        item5 = create(:item, name: "basket", description: 'wish this was a bALL of fun', merchant: merchant)
        item6 = create(:item, name: "wrong", description: 'wish this was a bALL of fun', merchant: merchant)

        expect(Item.case_insensitive_search("asket")).to eq(item2)
      end

      it 'returns nil if nothing is found' do
        merchant = create(:merchant)
        item1 = create(:item, name: "Compasket", merchant: merchant)

        expect(Item.case_insensitive_search("n")).to eq(nil)
      end
    end

    describe '::fetch_item' do
      it 'returns the requested item' do
        merchant = create(:merchant)
        item = create(:item, merchant: merchant)
        expect(Item.fetch_item(item)).to eq(item)
      end
    end

    describe '::search_via_min_price' do
      it 'returns the requested item inclusive ordered by name' do
        merchant = create(:merchant)
        item = create(:item, merchant: merchant, unit_price: 3, name: 'bob')
        item2 = create(:item, merchant: merchant, unit_price: 3, name: 'cob')
        expect(Item.search_via_min_price(3)).to eq(item)
      end

      it 'returns nil if price is above any items' do
        merchant = create(:merchant)
        item = create(:item, merchant: merchant, unit_price: 3)
        expect(Item.search_via_min_price(3.1)).to eq(nil)
      end
    end

    describe '::search_via_max_price' do
      it 'returns the first requested item inclusive of price ordered by name' do
        merchant = create(:merchant)
        item = create(:item, merchant: merchant, unit_price: 3, name: 'bob')
        item2 = create(:item, merchant: merchant, unit_price: 3, name: 'cob')
        expect(Item.search_via_max_price(3)).to eq(item)
      end

      it 'returns nil if price is above any items' do
        merchant = create(:merchant)
        item = create(:item, merchant: merchant, unit_price: 3)
        expect(Item.search_via_max_price(2)).to eq(nil)
      end
    end

    describe '::search_via_both_prices' do
      it 'returns the first requested item inclusive of prices ordered by name' do
        merchant = create(:merchant)
        item = create(:item, merchant: merchant, unit_price: 3, name: 'bob')
        item2 = create(:item, merchant: merchant, unit_price: 5, name: 'cob')
        expect(Item.search_via_both_prices(2,4)).to eq(item)
      end

      it 'returns the first requested item inclusive of prices ordered by name' do
        merchant = create(:merchant)
        item = create(:item, merchant: merchant, unit_price: 1, name: 'bob')
        item2 = create(:item, merchant: merchant, unit_price: 5, name: 'cob')
        expect(Item.search_via_both_prices(1,4)).to eq(item)
      end

      it 'returns the first requested item inclusive of prices ordered by name' do
        merchant = create(:merchant)
        item = create(:item, merchant: merchant, unit_price: 5, name: 'bob')
        item2 = create(:item, merchant: merchant, unit_price: 5, name: 'cob')
        expect(Item.search_via_both_prices(1,5)).to eq(item)
      end

      it 'returns the first requested item inclusive of prices ordered by name' do
        merchant = create(:merchant)
        item = create(:item, merchant: merchant, unit_price: 3, name: 'lower in alphabet')
        item2 = create(:item, merchant: merchant, unit_price: 3, name: 'higher in alphabet')
        expect(Item.search_via_both_prices(1,5)).to eq(item2)
      end

      it 'returns nil if price is above any items' do
        merchant = create(:merchant)
        item = create(:item, merchant: merchant, unit_price: 3)
        expect(Item.search_via_both_prices(1,2)).to eq(nil)
      end
    end
  end
end
