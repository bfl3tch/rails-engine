require 'rails_helper'

RSpec.describe MerchantsFacade do
  describe 'class methods' do
    describe '::fetch_requested_merchants' do
      it 'returns merchants with the requested parameters appropriately' do
        create_list(:merchant, 50)

        expect(MerchantsFacade.fetch_requested_merchants(100, 0).count).to eq(50)
        expect(MerchantsFacade.fetch_requested_merchants(50, 60).count).to eq(0)
        expect(MerchantsFacade.fetch_requested_merchants(25, 20).count).to eq(25)
        expect(MerchantsFacade.fetch_requested_merchants(50, 0).count).to eq(50)
      end
    end
  end
end
