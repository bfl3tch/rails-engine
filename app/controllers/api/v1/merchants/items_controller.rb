class Api::V1::Merchants::ItemsController < ApplicationController
  before_action :set_merchant, only: [:show]

  def index
    json_response(MerchantSerializer.new(merchant_items), status)

  end

  private

  def set_merchant
    @merchant = Merchant.find_by_id(params[:id])
  end
end
