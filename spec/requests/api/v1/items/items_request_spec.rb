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

      it 'sents a list of less than 20 back if its requested' do
        merchant = create(:merchant)
        create_list(:item, 21, merchant: merchant)
        get '/api/v1/items?per_page=10&page=1'

        items = JSON.parse(response.body)

        expect(response).to be_successful
        expect(items["data"].count).to eq(10)
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

  describe 'create request' do
    context 'happy path' do
      it 'creates an item and saves it to the database' do
        create(:merchant, id: 1)
        item_params =
          (
            {
            name: "Fake new item",
            description: "Bunch of latin words and stuff",
            unit_price: 670.76,
            merchant_id: 1
            }
          )
        headers = {"CONTENT_TYPE" => "application/json"}

        expect(Item.all.count).to eq(0)
        post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

        expect(response.status).to eq(201)
        expect(Item.all.count).to eq(1)
        expect(Item.all.last.name).to eq("Fake new item")
        expect(Item.all.last.merchant_id).to eq(1)
      end
    end

    context 'sad path' do
      it 'gives a 400 bad request error if bad/missing attributes' do
        create(:merchant, id: 1)
        item_params =
          (
            {
            name: "Fake new item",
            description: "Bunch of latin words and stuff",
            unit_price: 670.76,
            merchant_id: 0
            }
          )
        headers = {"CONTENT_TYPE" => "application/json"}

        expect(Item.all.count).to eq(0)
        post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

        expect(response.status).to eq(400)
        expect(Item.all.count).to eq(0)
      end
    end
  end

  describe 'update request' do
    context 'happy path' do
      it 'updates the requested item' do
        merchant = create(:merchant)
        item = create(:item, merchant: merchant, name: 'Poolstick')
        item_params =
          (
            {
              id: item.id,
              name: "Fake new item",
              description: "Bunch of latin words and stuff",
              unit_price: 670.76,
              merchant_id: merchant.id
            }
          )
        headers = {"CONTENT_TYPE" => "application/json"}

        put "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)

        updated_item = JSON.parse(response.body)

        expect(response).to be_successful
        expect(updated_item['data']['id'].to_i).to eq(item.id)
        expect(updated_item['data']['attributes']['name']).to eq("Fake new item")
      end

      it 'allows overwrites without the merchant id present' do
        merchant = create(:merchant, id: 1)
        merchant2 = create(:merchant, id: 2)
        item = create(:item, id: 1, merchant: merchant, name: 'Poolstick')
        item_params =
          (
            {
              name: "Fake new item",
            }
          )
        headers = {"CONTENT_TYPE" => "application/json"}
        # require "pry"; binding.pry
        put "/api/v1/items/1", headers: headers, params: JSON.generate(item: item_params)

        updated_item = JSON.parse(response.body)

        expect(response).to be_successful
        expect(updated_item['data']['id'].to_i).to eq(item.id)
        expect(updated_item['data']['attributes']['name']).to eq("Fake new item")
      end

      it 'allows overwrites without the merchant id present' do
        merchant = create(:merchant, id: 1)
        merchant2 = create(:merchant, id: 2)
        item = create(:item, id: 1, merchant: merchant, name: 'Poolstick')
        item_params =
          (
            {
              name: "Fake new item",
              merchant_id: 3
            }
          )
        headers = {"CONTENT_TYPE" => "application/json"}
        # require "pry"; binding.pry
        put "/api/v1/items/1", headers: headers, params: JSON.generate(item: item_params)

        updated_item = JSON.parse(response.body)

        expect(response).to be_successful
        expect(updated_item['data']['id'].to_i).to eq(item.id)
        expect(updated_item['data']['attributes']['name']).to eq("Fake new item")
      end
    end

    context 'sad path' do
      it 'responds to bad queries with a 404' do
        merchant = create(:merchant)
        item = create(:item, id: 1, merchant: merchant, name: 'Poolstick')
        item_params =
          (
            {
              id: 1,
              name: "Fake new item",
              description: "Bunch of latin words and stuff",
              unit_price: 670.76,
              merchant_id: merchant.id
            }
          )
        headers = {"CONTENT_TYPE" => "application/json"}

        put "/api/v1/items/2", headers: headers, params: JSON.generate(item: item_params)
        expect(response.body).to include('No item found with that ID')
        expect(response.status).to eq(404)
      end

      xit 'responds to bad merchant id overwrites with a 404' do
        merchant = create(:merchant, id: 1)
        merchant2 = create(:merchant, id: 2)
        item = create(:item, id: 1, merchant: merchant, name: 'Poolstick')
        item_params =
          (
            {
              id: 1,
              name: "Fake new item",
              description: "Bunch of latin words and stuff",
              unit_price: 670.76,
              merchant_id: 3
            }
          )
        headers = {"CONTENT_TYPE" => "application/json"}

        put "/api/v1/items/2", headers: headers, params: JSON.generate(item: item_params)
        expect(response.body).to include("Merchant ID must match an existing Merchant")
        expect(response.status).to eq(404)
      end
    end
  end

  describe 'destroy request' do
    context 'happy path' do
      it 'deletes the specified item' do
        merchant = create(:merchant)
        item = create(:item, merchant: merchant)

        expect(Item.count).to eq(1)

        delete "/api/v1/items/#{item.id}"

        expect(response).to be_successful
        expect(Item.count).to eq(0)
        expect{ Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
