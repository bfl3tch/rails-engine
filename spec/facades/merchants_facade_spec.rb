require 'rails_helper'

RSpec.describe MerchantsFacade do
  describe 'class methods' do
    describe '::fetch_requested_merchants' do
      it 'returns merchants with the requested parameters appropriately' do
        # the page parameter (2nd parameter here) is subtracted by 1 and multiplied by 20 (by the page method below) before arriving as argument in this method
        create_list(:merchant, 50)

        expect(MerchantsFacade.fetch_requested_merchants(100, 0).count).to eq(50)
        expect(MerchantsFacade.fetch_requested_merchants(50, 60).count).to eq(0)
        expect(MerchantsFacade.fetch_requested_merchants(25, 20).count).to eq(25)
        expect(MerchantsFacade.fetch_requested_merchants(50, 0).count).to eq(50)
      end
    end

    describe '::per_page' do
      it 'can return a default of 20 with nil inbound params' do
        expect(MerchantsFacade.per_page(nil)).to eq(20)
      end

      it 'can return a different number if provided' do
        expect(MerchantsFacade.per_page(50)).to eq(50)
        expect(MerchantsFacade.per_page(20)).to eq(20)
      end
    end

    describe '::page' do
      it 'takes the params and calculates how many records to skip in multiples of 20' do
        expect(MerchantsFacade.page(1)).to eq(0)
        expect(MerchantsFacade.page(2)).to eq(20)
        expect(MerchantsFacade.page(3)).to eq(40)
        expect(MerchantsFacade.page(4)).to eq(60)
      end

      it 'returns zero for any negative values entered in query params' do
        expect(MerchantsFacade.page(-1)).to eq(0)
        expect(MerchantsFacade.page(-100)).to eq(0)
        expect(MerchantsFacade.page(-15454)).to eq(0)
      end
    end
  end
end
