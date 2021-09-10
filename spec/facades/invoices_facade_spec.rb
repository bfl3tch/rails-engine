require 'rails_helper'

RSpec.describe InvoicesFacade do
  describe 'class methods' do
    describe '::rank_by_potential_revenue' do
      it 'returns merchants with the requested parameters appropriately' do
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
        invoice_item_3 = create(:invoice_item, item: item_3, invoice: invoice_3, quantity: 10, unit_price: 2.65415)

        transaction_1 = create(:transaction, invoice: invoice_1, result: 'success')
        transaction_2 = create(:transaction, invoice: invoice_2, result: 'success')

        expect(InvoicesFacade.rank_by_potential_revenue(1).first).to eq(invoice_1)
      end
    end
  end
end
