require 'rails_helper'

RSpec.describe "Item Merchant API" do
  describe 'index request' do
    context 'happy path' do
      it 'finds the associated merchant with the item id' do
        merchant = create(:merchant, id: 1)
        item = create(:item, merchant: merchant, id: 2)

        get "/api/v1/items/#{item.id}/merchant"

        expect(response).to be_successful
      end
    end

    context 'sad path' do
      it 'returns an error if the associated merchant with the item id is nil' do
        merchant = create(:merchant, id: 1)
        item = create(:item, merchant: merchant, id: 2)

        get "/api/v1/items/1/merchant"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)
      end
    end
  end
end
