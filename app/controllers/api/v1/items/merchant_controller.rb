class Api::V1::Items::MerchantController < ApplicationController
  before_action :set_item, only: [:index]

  def index
    json_response(MerchantSerializer.new(@merchant), status) if @item && @merchant
    json_response(ErrorItemSerializer.new(@error_item), :not_found) if @item.nil?
  end

  private

  def set_item
    @item = Item.find_by_id(params[:item_id])
    @merchant = Merchant.find_by_id(@item.merchant_id) if @item
    @error_item = ErrorItem.new("No item found with that ID") if @item.nil?
  end
end
