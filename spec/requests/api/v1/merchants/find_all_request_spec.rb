require 'rails_helper'

RSpec.describe 'Merchants find all controller' do
  describe 'index request' do
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

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(response.body).to include("Need a valid name")
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
