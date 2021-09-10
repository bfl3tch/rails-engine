require 'rails_helper'

RSpec.describe "Merchants" do
  describe 'index request' do
    context 'no query params' do
      it 'sends a list of all merchants' do
        create_list(:merchant, 3)

        get '/api/v1/merchants'
        merchants = JSON.parse(response.body)

        expect(response).to be_successful
        expect(merchants.class).to eq(Hash)
        expect(merchants["data"].count).to eq(3)
      end

      it 'sents a list of 20 back if there are more than 20' do
        create_list(:merchant, 21)

        get '/api/v1/merchants'
        merchants = JSON.parse(response.body)

        expect(response).to be_successful
        expect(merchants["data"].count).to eq(20)
      end
    end

    context 'with only per_page params' do
      it 'sends a list back of more than 20 if requested, but not the whole list' do
        create_list(:merchant, 30)

        get '/api/v1/merchants?per_page=25'
        merchants = JSON.parse(response.body)

        expect(response).to be_successful
        expect(merchants["data"].count).to eq(25)
      end

      it 'sends a list back of all items if more than the total is requested' do
        create_list(:merchant, 30)

        get '/api/v1/merchants?per_page=50'
        merchants = JSON.parse(response.body)

        expect(response).to be_successful
        expect(merchants["data"].count).to eq(30)

      end
    end

    context 'with only page params' do
      it 'sends back one page if requested' do
        create_list(:merchant, 30)

        get '/api/v1/merchants?page=1'
        merchants = JSON.parse(response.body)

        expect(response).to be_successful
        expect(merchants["data"].count).to eq(20)
      end

      it 'sends back the page with the remainder of counting incrementally by 20 leftover' do
        create_list(:merchant, 30)

        get '/api/v1/merchants?page=2'
        merchants = JSON.parse(response.body)

        expect(response).to be_successful
        expect(merchants["data"].count).to eq(10)
      end

      it 'sends a an empty array back if too large a page is requested' do
        create_list(:merchant, 30)

        get '/api/v1/merchants?page=5'
        merchants = JSON.parse(response.body)

        expect(response).to be_successful
        expect(merchants["data"].count).to eq(0)

      end
    end

    context 'with both params' do
      it 'uses the per_page math to determine the remainders for the first page' do
        create_list(:merchant, 30)

        get '/api/v1/merchants?per_page=25&page=1'
        merchants = JSON.parse(response.body)

        expect(response).to be_successful
        expect(merchants.class).to eq(Hash)
        expect(merchants["data"].count).to eq(25)
      end

      it 'uses the per_page math to determine the remainders for other pages' do
        create_list(:merchant, 50)

        get '/api/v1/merchants?per_page=20&page=3'
        merchants = JSON.parse(response.body)

        expect(response).to be_successful
        expect(merchants["data"].count).to eq(10)
      end

      it 'sends a list back of all items if more than the total is requested' do
        create_list(:merchant, 30)

        get '/api/v1/merchants?per_page=50&page=1'
        merchants = JSON.parse(response.body)

        expect(response).to be_successful
        expect(merchants["data"].count).to eq(30)
      end
    end
  end

  describe 'show request' do
    context 'happy path' do
      it 'returns the requested merchant' do
        merchant = Merchant.create!(name: 'Kramer')

        get "/api/v1/merchants/#{merchant.id}"
        merchant = JSON.parse(response.body)

        expect(response).to be_successful
        expect(merchant["data"]["attributes"]["name"]).to eq("Kramer")
      end
    end

    context 'sad path' do
      it 'responds to bad queries with a 404' do
        merchant = Merchant.create!(name: 'Kramer')

        get "/api/v1/merchants/#{merchant.id + 1}"

        expect(response.body).to include("No merchant found with that ID")
        expect(response.status).to eq(404)
      end
    end
  end
end
