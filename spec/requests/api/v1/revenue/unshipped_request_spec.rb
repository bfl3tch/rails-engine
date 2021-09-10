require 'rails_helper'

RSpec.describe 'Revenue Unshipped Controller' do
  describe 'the index action - unshipped invoices' do
    context 'happy path' do
      it 'returns the invoices ranked by potential revenue' do
        merchant_1 = create(:merchant, id: 1)

        customer_1 = create(:customer)
        customer_2 = create(:customer)

        item_1 = create(:item, merchant: merchant_1)
        item_2 = create(:item, merchant: merchant_1)
        item_3 = create(:item, merchant: merchant_1)

        invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1, status: 'packaged')
        invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_2, status: 'packaged')
        invoice_3 = create(:invoice, merchant: merchant_1, customer: customer_1, status: 'packaged')

        invoice_item_1 = create(:invoice_item, item: item_1, invoice: invoice_1, quantity: 12, unit_price: 1.564)
        invoice_item_2 = create(:invoice_item, item: item_2, invoice: invoice_2, quantity: 5, unit_price: 2.65415)
        invoice_item_3 = create(:invoice_item, item: item_3, invoice: invoice_3, quantity: 5, unit_price: 2.65415)

        transaction_1 = create(:transaction, invoice: invoice_1, result: 'success')
        transaction_2 = create(:transaction, invoice: invoice_2, result: 'success')

        get '/api/v1/revenue/unshipped'
        results = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(results[:data][0][:type]).to eq("unshipped_order")
        expect(results[:data].count).to eq(2)
      end

      it 'returns the invoices ranked by potential revenue and specifies how many to return' do
        merchant_1 = create(:merchant, id: 1)

        customer_1 = create(:customer)
        customer_2 = create(:customer)

        item_1 = create(:item, merchant: merchant_1)
        item_2 = create(:item, merchant: merchant_1)
        item_3 = create(:item, merchant: merchant_1)

        invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1, status: 'packaged')
        invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_2, status: 'packaged')
        invoice_3 = create(:invoice, merchant: merchant_1, customer: customer_1, status: 'packaged')

        invoice_item_1 = create(:invoice_item, item: item_1, invoice: invoice_1, quantity: 12, unit_price: 1.564)
        invoice_item_2 = create(:invoice_item, item: item_2, invoice: invoice_2, quantity: 5, unit_price: 2.65415)
        invoice_item_3 = create(:invoice_item, item: item_3, invoice: invoice_3, quantity: 5, unit_price: 2.65415)

        transaction_1 = create(:transaction, invoice: invoice_1, result: 'success')
        transaction_2 = create(:transaction, invoice: invoice_2, result: 'success')

        get '/api/v1/revenue/unshipped?quantity=2'
        results = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(results[:data][0][:type]).to eq("unshipped_order")
        expect(results[:data].count).to eq(2)
      end
    end

    context 'sad path' do
      it 'throws an error if the params are less than 0' do
        merchant_1 = create(:merchant, id: 1)

        customer_1 = create(:customer)
        customer_2 = create(:customer)

        item_1 = create(:item, merchant: merchant_1)
        item_2 = create(:item, merchant: merchant_1)
        item_3 = create(:item, merchant: merchant_1)

        invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1, status: 'packaged')
        invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_2, status: 'packaged')
        invoice_3 = create(:invoice, merchant: merchant_1, customer: customer_1, status: 'packaged')

        invoice_item_1 = create(:invoice_item, item: item_1, invoice: invoice_1, quantity: 12, unit_price: 1.564)
        invoice_item_2 = create(:invoice_item, item: item_2, invoice: invoice_2, quantity: 5, unit_price: 2.65415)
        invoice_item_3 = create(:invoice_item, item: item_3, invoice: invoice_3, quantity: 5, unit_price: 2.65415)

        transaction_1 = create(:transaction, invoice: invoice_1, result: 'success')
        transaction_2 = create(:transaction, invoice: invoice_2, result: 'success')

        get '/api/v1/revenue/unshipped?quantity=-2'

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end
    end
  end
end
