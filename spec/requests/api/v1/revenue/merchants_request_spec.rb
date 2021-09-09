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
  end
end
