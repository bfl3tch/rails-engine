require 'rails_helper'

RSpec.describe "Merchant Items API" do
  describe 'index request' do
    context 'happy path' do
      it 'sends a list of all items belonging to the merchant' do
        merchant = create(:merchant, id: 1)
        item1 = create(:item, merchant: merchant)
        item2 = create(:item, merchant: merchant)
        item3 = create(:item, merchant: merchant)


        get '/api/v1/merchants/1/items'
        merchant = JSON.parse(response.body)
        expect(response).to be_successful
        expect(merchant.class).to eq(Hash)
      end
    end

    context 'sad path' do
      it 'returns a 404 if no merchant found' do
        merchant = create(:merchant, id: 1)
        item1 = create(:item, merchant: merchant)
        item2 = create(:item, merchant: merchant)
        item3 = create(:item, merchant: merchant)

        get '/api/v1/merchants/2/items'

        expect(response.status).to eq(404)
      end
    end
  end
end
