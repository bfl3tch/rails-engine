require 'rails_helper'

RSpec.describe 'Revenue Merchants Controller' do
  describe 'the index action - merchants with most revenue' do
    context 'happy path' do
      it 'returns the merchants requested in quantity ranked descending by revenue' do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)

        get '/api/v1/revenue/merchants?quantity=2'

        expect(response).to be_successful
      end
    end

    context 'sad path' do
      it 'throws an error if the params are missing' do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)

        get '/api/v1/revenue/merchants'

        expect(response).to_not be_successful
      end

      it 'throws an error if the params are less than 0' do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)

        get '/api/v1/revenue/merchants?quantity=-2'

        expect(response).to_not be_successful
      end
    end
  end

  describe 'the show action - merchant revenue calulation' do
    it 'determines the revenue for an individual merchant' do
      merchant_1 = create(:merchant, id: 1)

      customer_1 = create(:customer)
      customer_2 = create(:customer)


      item_1 = create(:item, merchant: merchant_1)
      item_2 = create(:item, merchant: merchant_1)
      item_3 = create(:item, merchant: merchant_1)

      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1, status: 'shipped')
      invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_2, status: 'shipped')

      invoice_item_1 = create(:invoice_item, item: item_1, invoice: invoice_1, quantity: 12, unit_price: 1.564)
      invoice_item_2 = create(:invoice_item, item: item_2, invoice: invoice_2, quantity: 5, unit_price: 2.65415)

      transaction_1 = create(:transaction, invoice: invoice_1, result: 'success')
      transaction_2 = create(:transaction, invoice: invoice_2, result: 'success')

      get '/api/v1/revenue/merchants/1'
      results = JSON.parse(response.body)

      expect(response).to be_successful
      expect(results).to eq({"data" => {"attributes" => {"revenue" => 32.03875}, "id" => "1", "type" => "merchant_revenue"}})
    end

    it 'renders a 404 if the url goes to an invalid merchant' do
      merchant_1 = create(:merchant, id: 1)

      get '/api/v1/revenue/merchants/2'
      results = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(results.keys).to include(:error_message)
      expect(results[:error_message][:error_message]).to include("No merchant found with that ID")
    end
  end
end
