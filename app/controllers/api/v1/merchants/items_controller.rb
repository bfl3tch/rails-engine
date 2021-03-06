class Api::V1::Merchants::ItemsController < ApplicationController
  before_action :set_merchant, only: [:index]
  include Response
  include ExceptionHandler

  def index
    items = MerchantItemsFacade.fetch_merchant_items(@merchant)
    json_response(ItemSerializer.new(items), status) if @merchant
    json_response({error: 'No merchant with that ID found'}, :not_found) if @merchant.nil?
  end

  private

  def set_merchant
    @merchant = Merchant.find_by_id(params[:merchant_id])
  end
end
