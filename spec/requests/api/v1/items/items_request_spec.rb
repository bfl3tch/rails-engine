require 'rails_helper'

RSpec.describe "Items API" do
  describe 'index request' do
    context 'no query params' do
      it 'sends a list of all items' do
        merchant = create(:merchant)
        create_list(:item, 3, merchant: merchant)

        get '/api/v1/items'

        items = JSON.parse(response.body)

        expect(response).to be_successful
        expect(items.class).to eq(Hash)
        expect(items["data"].count).to eq(3)
      end

      it 'sents a list of 20 back if there are more than 20' do
        merchant = create(:merchant)
        create_list(:item, 21, merchant: merchant)
        get '/api/v1/items'

        items = JSON.parse(response.body)

        expect(response).to be_successful
        expect(items["data"].count).to eq(20)
      end
    end

    context 'with only per_page params' do
      it 'sends a list back of more than 20 if requested, but not the whole list' do
        merchant = create(:merchant)
        create_list(:item, 30, merchant: merchant)

        get '/api/v1/items?per_page=25'

        items = JSON.parse(response.body)

        expect(response).to be_successful
        expect(items["data"].count).to eq(25)
      end

      it 'sends a list back of all items if more than the total is requested' do
        merchant = create(:merchant)
        create_list(:item, 30, merchant: merchant)

        get '/api/v1/items?per_page=50'

        items = JSON.parse(response.body)

        expect(response).to be_successful
        expect(items["data"].count).to eq(30)

      end
    end

    context 'with only page params' do
      it 'sends back one page if requested' do
        merchant = create(:merchant)
        create_list(:item, 30, merchant: merchant)

        get '/api/v1/items?page=1'

        items = JSON.parse(response.body)

        expect(response).to be_successful
        expect(items["data"].count).to eq(20)
      end

      it 'sends back the page with the remainder of counting incrementally by 20 leftover' do
        merchant = create(:merchant)
        create_list(:item, 30, merchant: merchant)

        get '/api/v1/items?page=2'

        items = JSON.parse(response.body)

        expect(response).to be_successful
        expect(items["data"].count).to eq(10)
      end

      it 'sends a an empty array back if too large a page is requested' do
        merchant = create(:merchant)
        create_list(:item, 30, merchant: merchant)

        get '/api/v1/items?page=5'

        items = JSON.parse(response.body)

        expect(response).to be_successful
        expect(items["data"].count).to eq(0)

      end
    end

    context 'with both params' do
      it 'uses the per_page math to determine the remainders for the first page' do
        merchant = create(:merchant)
        create_list(:item, 30, merchant: merchant)

        get '/api/v1/items?per_page=25&page=1'

        items = JSON.parse(response.body)

        expect(response).to be_successful
        expect(items.class).to eq(Hash)
        expect(items["data"].count).to eq(25)
      end

      it 'uses the per_page math to determine the remainders for other pages' do
        merchant = create(:merchant)
        create_list(:item, 50, merchant: merchant)

        get '/api/v1/items?per_page=20&page=3'

        items = JSON.parse(response.body)

        expect(response).to be_successful
        expect(items["data"].count).to eq(10)
      end

      it 'sends a list back of all items if more than the total is requested' do
        merchant = create(:merchant)
        create_list(:item, 30, merchant: merchant)

        get '/api/v1/items?per_page=50&page=1'

        items = JSON.parse(response.body)

        expect(response).to be_successful
        expect(items["data"].count).to eq(30)
      end
    end
  end

  describe 'show request' do
    context 'happy path' do
      it 'returns the requested item' do
        merchant = create(:merchant)
        item = create(:item, merchant: merchant, name: 'Poolstick')

        get "/api/v1/items/#{item.id}"

        item = JSON.parse(response.body)
        expect(response).to be_successful
        expect(item['data']['attributes']['name']).to eq('Poolstick')
      end
    end

    context 'sad path' do
      it 'responds to bad queries with a 404' do
        merchant = create(:merchant)
        item = create(:item, merchant: merchant)

        get "/api/v1/items/#{item.id + 1}"

        expect(response.body).to include('No item found with that ID')
        expect(response.status).to eq(404)
      end
    end
  end
end
