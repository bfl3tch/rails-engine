require 'rails_helper'

RSpec.describe "Item Find" do
  describe 'index request' do
    it 'searches through the items case sensitively' do
      merchant = create(:merchant, id: 1)
      create(:item, name: "basket", merchant: merchant)
      create(:item, name: "baseBALL", merchant: merchant)
      create(:item, name: "football", merchant: merchant)
      create(:item, name: "tennis ball", merchant: merchant)

      get '/api/v1/items/find?name=ball'

      expect(response).to be_successful
      expect(response.body).to include('baseBALL')
      expect(response.body).to_not include('basket')
    end

    it 'returns an error if nothing is found' do
      merchant = create(:merchant, id: 1)
      create(:item, name: "hike", merchant: merchant)
      create(:item, name: "bike", merchant: merchant)
      create(:item, name: "snow", merchant: merchant)
      create(:item, name: "skate", merchant: merchant)

      get '/api/v1/items/find?name=ball'

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end

    it 'returns an error if nothing is searched for' do
      merchant = create(:merchant, id: 1)
      create(:item, name: "basket", merchant: merchant)
      create(:item, name: "baseBALL", merchant: merchant)
      create(:item, name: "football", merchant: merchant)
      create(:item, name: "tennis ball", merchant: merchant)

      get '/api/v1/items/find?'

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end

    it 'searches via minimum price params and returns the first alphabetical match' do
      merchant = create(:merchant, id: 1)
      create(:item, name: "jsomething", merchant: merchant, unit_price: 3)
      create(:item, name: "asomething", merchant: merchant, unit_price: 3)
      create(:item, name: "fsomething", merchant: merchant, unit_price: 3)

      get '/api/v1/items/find?min_price=2'

      expect(response.body).to include('asomething')
      expect(response.body).to_not include('jsomething')
      expect(response.body).to_not include('fsomething')
    end

    it 'responds with an error if min price has no match' do
      merchant = create(:merchant, id: 1)
      create(:item, name: "jsomething", merchant: merchant, unit_price: 3)
      create(:item, name: "asomething", merchant: merchant, unit_price: 3)
      create(:item, name: "fsomething", merchant: merchant, unit_price: 3)

      get '/api/v1/items/find?min_price=4'

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(response.body).to_not include('asomething')
      expect(response.body).to_not include('jsomething')
      expect(response.body).to_not include('fsomething')
    end

    it 'searches via maximum price params and returns the first alphabetical match' do
      merchant = create(:merchant, id: 1)
      create(:item, name: "jsomething", merchant: merchant, unit_price: 3)
      create(:item, name: "asomething", merchant: merchant, unit_price: 3)
      create(:item, name: "fsomething", merchant: merchant, unit_price: 3)

      get '/api/v1/items/find?max_price=4'

      expect(response.body).to include('asomething')
      expect(response.body).to_not include('jsomething')
      expect(response.body).to_not include('fsomething')
    end

    it 'responds with an error if max price has no match' do
      merchant = create(:merchant, id: 1)
      create(:item, name: "jsomething", merchant: merchant, unit_price: 3)
      create(:item, name: "asomething", merchant: merchant, unit_price: 3)
      create(:item, name: "fsomething", merchant: merchant, unit_price: 3)

      get '/api/v1/items/find?max_price=2'

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(response.body).to_not include('asomething')
      expect(response.body).to_not include('jsomething')
      expect(response.body).to_not include('fsomething')
    end

    it 'searches via both prices and returns the first alphabetical match' do
      merchant = create(:merchant, id: 1)
      create(:item, name: "jsomething", merchant: merchant, unit_price: 3)
      create(:item, name: "asomething", merchant: merchant, unit_price: 3)
      create(:item, name: "fsomething", merchant: merchant, unit_price: 3)

      get '/api/v1/items/find?min_price=2&max_price=4'

      expect(response.body).to include('asomething')
      expect(response.body).to_not include('jsomething')
      expect(response.body).to_not include('fsomething')
    end

    it 'returns an error if you try to search both name and min price' do
      merchant = create(:merchant, id: 1)
      create(:item, name: "jsomething", merchant: merchant, unit_price: 3)
      create(:item, name: "asomething", merchant: merchant, unit_price: 3)
      create(:item, name: "fsomething", merchant: merchant, unit_price: 3)

      get '/api/v1/items/find?name=something&min_price=2'

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end

    it 'returns an error if you try to search both name and max price' do
      merchant = create(:merchant, id: 1)
      create(:item, name: "jsomething", merchant: merchant, unit_price: 3)
      create(:item, name: "asomething", merchant: merchant, unit_price: 3)
      create(:item, name: "fsomething", merchant: merchant, unit_price: 3)

      get '/api/v1/items/find?name=something&max_price=4'

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end

    it 'returns an error if you try to search both name and min AND max price' do
      merchant = create(:merchant, id: 1)
      create(:item, name: "jsomething", merchant: merchant, unit_price: 3)
      create(:item, name: "asomething", merchant: merchant, unit_price: 3)
      create(:item, name: "fsomething", merchant: merchant, unit_price: 3)

      get '/api/v1/items/find?name=something&min_price=2&max_price=4'

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end
  end
end
