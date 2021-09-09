require 'rails_helper'

RSpec.describe "Item Find API" do
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

    it 'returns a 404 if nothing is found' do
      merchant = create(:merchant, id: 1)
      create(:item, name: "hike", merchant: merchant)
      create(:item, name: "bike", merchant: merchant)
      create(:item, name: "snow", merchant: merchant)
      create(:item, name: "skate", merchant: merchant)
      get '/api/v1/items/find?name=ball'

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end

    it 'returns a 404 if nothing is searched for' do
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

    it 'responds with a 404 error if min price has no match' do
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

    it 'responds with a 404 error if max price has no match' do
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

    it 'returns a 404 if you try to search both name and min price' do
      merchant = create(:merchant, id: 1)
      create(:item, name: "jsomething", merchant: merchant, unit_price: 3)
      create(:item, name: "asomething", merchant: merchant, unit_price: 3)
      create(:item, name: "fsomething", merchant: merchant, unit_price: 3)
      get '/api/v1/items/find?name=something&min_price=2'

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end

    it 'returns a 404 if you try to search both name and max price' do
      merchant = create(:merchant, id: 1)
      create(:item, name: "jsomething", merchant: merchant, unit_price: 3)
      create(:item, name: "asomething", merchant: merchant, unit_price: 3)
      create(:item, name: "fsomething", merchant: merchant, unit_price: 3)
      get '/api/v1/items/find?name=something&max_price=4'

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end

    it 'returns a 404 if you try to search both name and min AND max price' do
      merchant = create(:merchant, id: 1)
      create(:item, name: "jsomething", merchant: merchant, unit_price: 3)
      create(:item, name: "asomething", merchant: merchant, unit_price: 3)
      create(:item, name: "fsomething", merchant: merchant, unit_price: 3)
      get '/api/v1/items/find?name=something&min_price=2&max_price=4'

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end
  end

  describe 'show request' do
    it 'returns all merchants if they have partial matches to the search case insensitive' do
      merchant1 = create(:merchant, name: 'Joe')
      merchant2 = create(:merchant, name: 'joe')
      merchant3 = create(:merchant, name: 'Joel')
      merchant4 = create(:merchant, name: 'joelneville')
      merchant5 = create(:merchant, name: 'bob')

      get '/api/v1/merchants/find_all?name=joe'

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(response.body).to include(merchant1.name)
      expect(response.body).to include(merchant2.name)
      expect(response.body).to include(merchant3.name)
      expect(response.body).to include(merchant4.name)
      expect(response.body).to_not include(merchant5.name)
    end

    it 'returns empty dataset if no params are given' do
      merchant1 = create(:merchant, name: 'Joe')
      merchant2 = create(:merchant, name: 'joe')
      merchant3 = create(:merchant, name: 'Joel')
      merchant4 = create(:merchant, name: 'joelneville')
      merchant5 = create(:merchant, name: 'bob')

      get '/api/v1/merchants/find_all'

      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(response.body).to eq("")
    end

    it 'returns empty dataset array if unmatching params are given' do
      merchant1 = create(:merchant, name: 'Joe')
      merchant2 = create(:merchant, name: 'joe')
      merchant3 = create(:merchant, name: 'Joel')
      merchant4 = create(:merchant, name: 'joelneville')
      merchant5 = create(:merchant, name: 'bob')

      get '/api/v1/merchants/find_all?name=marinatedsteak'

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(response.body).to eq("{\"data\":[]}")
    end
  end
end
