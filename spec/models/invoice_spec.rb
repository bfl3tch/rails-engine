require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'associations' do
    it { should belong_to(:customer) }
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:transactions) }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:status) }
  end

  describe 'class methods' do
    describe '::rank_by_potential_revenue' do
      it 'returns the merchants ordered by potential revenue descending' do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)
        merchant_3 = create(:merchant)

        customer_1 = create(:customer)
        customer_2 = create(:customer)
        customer_3 = create(:customer)

        item_1 = create(:item, merchant: merchant_1)
        item_2 = create(:item, merchant: merchant_2)
        item_3 = create(:item, merchant: merchant_3)

        invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1, status: 'packaged')
        invoice_2 = create(:invoice, merchant: merchant_2, customer: customer_2, status: 'packaged')
        invoice_3 = create(:invoice, merchant: merchant_3, customer: customer_3, status: 'packaged')

        invoice_item_1 = create(:invoice_item, item: item_1, invoice: invoice_1, quantity: 12, unit_price: 3)
        invoice_item_2 = create(:invoice_item, item: item_2, invoice: invoice_2, quantity: 20, unit_price: 4)
        invoice_item_3 = create(:invoice_item, item: item_3, invoice: invoice_3, quantity: 10, unit_price: 5)

        transaction_1 = create(:transaction, invoice: invoice_1, result: 'success')
        transaction_2 = create(:transaction, invoice: invoice_2, result: 'success')
        transaction_3 = create(:transaction, invoice: invoice_3, result: 'success')

        expect(Invoice.unshipped_potential_revenue(3)).to eq([invoice_2, invoice_3, invoice_1])
        expect(Invoice.unshipped_potential_revenue(2)).to eq([invoice_2, invoice_3])
        expect(Invoice.unshipped_potential_revenue(1)).to eq([invoice_2])
      end

      it 'returns the merchants ordered by revenue descending with floats' do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)
        merchant_3 = create(:merchant)

        customer_1 = create(:customer)
        customer_2 = create(:customer)
        customer_3 = create(:customer)

        item_1 = create(:item, merchant: merchant_1)
        item_2 = create(:item, merchant: merchant_2)
        item_3 = create(:item, merchant: merchant_3)

        invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1, status: 'packaged')
        invoice_2 = create(:invoice, merchant: merchant_2, customer: customer_2, status: 'packaged')
        invoice_3 = create(:invoice, merchant: merchant_3, customer: customer_3, status: 'packaged')

        invoice_item_1 = create(:invoice_item, item: item_1, invoice: invoice_1, quantity: 12, unit_price: 1.564)
        invoice_item_2 = create(:invoice_item, item: item_2, invoice: invoice_2, quantity: 5, unit_price: 2.65415)
        invoice_item_3 = create(:invoice_item, item: item_3, invoice: invoice_3, quantity: 10, unit_price: 3.2164)

        transaction_1 = create(:transaction, invoice: invoice_1, result: 'success')
        transaction_2 = create(:transaction, invoice: invoice_2, result: 'success')
        transaction_3 = create(:transaction, invoice: invoice_3, result: 'success')

        expect(Invoice.unshipped_potential_revenue(3)).to eq([invoice_3, invoice_1, invoice_2])
        expect(Invoice.unshipped_potential_revenue(2)).to eq([invoice_3, invoice_1])
        expect(Invoice.unshipped_potential_revenue(1)).to eq([invoice_3])
      end

      it 'returns nothing if they have shipped' do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)
        merchant_3 = create(:merchant)

        customer_1 = create(:customer)
        customer_2 = create(:customer)
        customer_3 = create(:customer)

        item_1 = create(:item, merchant: merchant_1)
        item_2 = create(:item, merchant: merchant_2)
        item_3 = create(:item, merchant: merchant_3)

        invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1, status: 'shipped')
        invoice_2 = create(:invoice, merchant: merchant_2, customer: customer_2, status: 'shipped')
        invoice_3 = create(:invoice, merchant: merchant_3, customer: customer_3, status: 'shipped')

        invoice_item_1 = create(:invoice_item, item: item_1, invoice: invoice_1, quantity: 12, unit_price: 1.564)
        invoice_item_2 = create(:invoice_item, item: item_2, invoice: invoice_2, quantity: 5, unit_price: 2.65415)
        invoice_item_3 = create(:invoice_item, item: item_3, invoice: invoice_3, quantity: 10, unit_price: 3.2164)

        transaction_1 = create(:transaction, invoice: invoice_1, result: 'success')
        transaction_2 = create(:transaction, invoice: invoice_2, result: 'success')
        transaction_3 = create(:transaction, invoice: invoice_3, result: 'success')

        expect(Invoice.unshipped_potential_revenue(3)).to eq([])
      end
    end
  end
end
