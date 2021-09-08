require 'rails_helper'

RSpec.describe "Item Find API" do
  describe 'index request' do
    it 'searches through the items case sensitively' do
      merchant = create(:merchant, id: 1)
      create(:item, name: "basketBALL", merchant: merchant)
      create(:item, name: "baseBALL", merchant: merchant)
      create(:item, name: "football", merchant: merchant)
      create(:item, name: "tennis ball", merchant: merchant)
      get '/api/v1/items/find?name=ball'

      expect(response).to be_successful
      expect(response.body).to include('football')
      expect(response.body).to include('tennis ball')
      expect(response.body).to_not include('basketBALL')
    end

    it 'returns objects that have both the name or description with a case sensitive match' do

    end
  end
end
