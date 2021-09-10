class Api::V1::Revenue::ItemsController < ApplicationController
  before_action :set_item, only: [:index]

  def index
    @item_revenue ? json_response(ItemRevenueSerializer.new(@item_revenue)) : json_response(ErrorItemSerializer.new(@error_merchant), :bad_request)
  end

  private

  def set_item
    if params[:quantity] && params[:quantity].to_i <= 0
      @error_merchant = ErrorMerchant.new("Quantity cannot be negative")
    elsif params[:quantity] && params[:quantity].to_i > 0
      quantity = params[:quantity]
    elsif params[:quantity].nil?
      quantity = 10
    end
    @item_revenue = ItemsFacade.rank_items_by_revenue(quantity) if quantity
  end
end
