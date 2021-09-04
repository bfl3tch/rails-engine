require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'associations' do
    it { should have_many(:items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
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
  end
end
