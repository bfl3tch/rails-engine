require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'associations' do
    it { should have_many(:items) }
    it { should have_many(:invoices) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'instance methods' do
    describe '#merchant_revenue' do
      it 'returns the revenue for one merchant' do
        merchant_1 = create(:merchant)

        customer_1 = create(:customer)
        customer_2 = create(:customer)
        customer_3 = create(:customer)

        item_1 = create(:item, merchant: merchant_1)
        item_2 = create(:item, merchant: merchant_1)

        invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1, status: 'shipped')

        invoice_item_1 = create(:invoice_item, item: item_1, invoice: invoice_1, quantity: 15, unit_price: 1)
        invoice_item_2 = create(:invoice_item, item: item_2, invoice: invoice_1, quantity: 20, unit_price: 2)

        transaction_1 = create(:transaction, invoice: invoice_1, result: 'success')

        expect(merchant_1.merchant_revenue).to eq(55)
      end

      it 'returns the revenue for one merchant with floats' do
        merchant_1 = create(:merchant)

        customer_1 = create(:customer)
        customer_2 = create(:customer)
        customer_3 = create(:customer)

        item_1 = create(:item, merchant: merchant_1)
        item_2 = create(:item, merchant: merchant_1)

        invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1, status: 'shipped')

        invoice_item_1 = create(:invoice_item, item: item_1, invoice: invoice_1, quantity: 15, unit_price: 123.56)
        invoice_item_2 = create(:invoice_item, item: item_2, invoice: invoice_1, quantity: 20, unit_price: 88.79)

        transaction_1 = create(:transaction, invoice: invoice_1, result: 'success')

        expect(merchant_1.merchant_revenue).to eq(3629.2000000000003)
      end
    end
  end

  describe 'class methods' do
    describe '::fetch_requested_merchants' do
      it 'returns merchants with the requested parameters appropriately' do
        # the page parameter (2nd parameter here) is subtracted by 1 and multiplied by 20 before arriving as argument in this method
        create_list(:merchant, 50)

        expect(Merchant.fetch_requested_merchants(100, 0).count).to eq(50)
        expect(Merchant.fetch_requested_merchants(50, 60).count).to eq(0)
        expect(Merchant.fetch_requested_merchants(25, 20).count).to eq(25)
        expect(Merchant.fetch_requested_merchants(50, 0).count).to eq(50)
      end
    end

    describe '::fetch_merchant_items' do
      it 'returns all items belonging to the merchant' do
        merchant = create(:merchant)
        item = create(:item, merchant: merchant)
        expect(Merchant.fetch_merchant_items(merchant)).to eq([item])
      end

      it 'doesnt return items from another merchant' do
        merchant1 = create(:merchant)
        merchant2 = create(:merchant)

        item1 = create(:item, merchant: merchant1)
        item2 = create(:item, merchant: merchant2)
        item3 = create(:item, merchant: merchant1)

        expect(Merchant.fetch_merchant_items(merchant1)).not_to eq([item2])
        expect(Merchant.fetch_merchant_items(merchant2)).not_to eq([item1, item3])
      end
    end

    describe '::find_by_name' do
      it 'returns all merchants with matches to that name' do
        merchant1 = create(:merchant, name: 'Joe')
        merchant2 = create(:merchant, name: 'joe')
        merchant3 = create(:merchant, name: 'Joel')
        merchant4 = create(:merchant, name: 'joelneville')
        merchant5 = create(:merchant, name: 'bob')

        expect(Merchant.find_by_name('joe')).to eq([merchant1, merchant3, merchant2, merchant4])
      end

      it 'doesnt return items from another merchant' do
        merchant1 = create(:merchant)
        merchant2 = create(:merchant)

        item1 = create(:item, merchant: merchant1)
        item2 = create(:item, merchant: merchant2)
        item3 = create(:item, merchant: merchant1)

        expect(Merchant.fetch_merchant_items(merchant1)).not_to eq([item2])
        expect(Merchant.fetch_merchant_items(merchant2)).not_to eq([item1, item3])
      end
    end

    describe '::most_revenue' do
      it 'returns the merchants ordered by revenue descending' do
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

        invoice_item_1 = create(:invoice_item, item: item_1, invoice: invoice_1, quantity: 12, unit_price: 1)
        invoice_item_2 = create(:invoice_item, item: item_2, invoice: invoice_2, quantity: 20, unit_price: 2)
        invoice_item_3 = create(:invoice_item, item: item_3, invoice: invoice_3, quantity: 10, unit_price: 3)

        transaction_1 = create(:transaction, invoice: invoice_1, result: 'success')
        transaction_2 = create(:transaction, invoice: invoice_2, result: 'success')
        transaction_3 = create(:transaction, invoice: invoice_3, result: 'success')

        expect(Merchant.most_revenue(3)).to eq([merchant_2, merchant_3, merchant_1])
        expect(Merchant.most_revenue(2)).to eq([merchant_2, merchant_3])
        expect(Merchant.most_revenue(1)).to eq([merchant_2])
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

        invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1, status: 'shipped')
        invoice_2 = create(:invoice, merchant: merchant_2, customer: customer_2, status: 'shipped')
        invoice_3 = create(:invoice, merchant: merchant_3, customer: customer_3, status: 'shipped')

        invoice_item_1 = create(:invoice_item, item: item_1, invoice: invoice_1, quantity: 12, unit_price: 1.564)
        invoice_item_2 = create(:invoice_item, item: item_2, invoice: invoice_2, quantity: 5, unit_price: 2.65415)
        invoice_item_3 = create(:invoice_item, item: item_3, invoice: invoice_3, quantity: 10, unit_price: 3.2164)

        transaction_1 = create(:transaction, invoice: invoice_1, result: 'success')
        transaction_2 = create(:transaction, invoice: invoice_2, result: 'success')
        transaction_3 = create(:transaction, invoice: invoice_3, result: 'success')

        expect(Merchant.most_revenue(3)).to eq([merchant_3, merchant_1, merchant_2])
        expect(Merchant.most_revenue(2)).to eq([merchant_3, merchant_1])
        expect(Merchant.most_revenue(1)).to eq([merchant_3])
      end
    end
  end
end
