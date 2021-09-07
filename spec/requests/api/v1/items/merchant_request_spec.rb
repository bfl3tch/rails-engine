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
  end
end
