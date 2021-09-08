class Api::V1::Items::FindController < ApplicationController
  # before_action :set_item, only: [:index]

  def index
    require "pry"; binding.pry
    @search_results = ItemsFacade.item_search(params[:name])
    # json_response(MerchantSerializer.new(@merchant), status) if @item && @merchant
    # json_response(ErrorItemSerializer.new(@error_item), :not_found) if @item.nil?
  end

  private

  def set_item
    # @item = Item.find_by_id(params[:item_id])
    # @merchant = Merchant.find_by_id(@item.merchant_id) if @item
    # @error_item = ErrorItem.new("No item found with that ID") if @item.nil?
  end
end
