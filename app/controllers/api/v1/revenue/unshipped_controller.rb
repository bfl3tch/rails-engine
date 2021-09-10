class Api::V1::Revenue::UnshippedController < ApplicationController
  before_action :get_revenue, only: [:index]

  def index
    json_response(UnshippedOrderSerializer.new(@potential_revenue_ranked), status) if @potential_revenue_ranked
  end

  private

  def get_revenue
    if params[:quantity] && params[:quantity].to_i <= 0
      @error_merchant = ErrorMerchant.new("Quantity cannot be negative")
      json_response(ErrorMerchantSerializer.new(@error_merchant), :bad_request)
    elsif params[:quantity] && params[:quantity].to_i > 0
      quantity = params[:quantity]
    elsif params[:quantity].nil?
      quantity = 10
    end
    @potential_revenue_ranked = InvoicesFacade.rank_by_potential_revenue(quantity) if quantity
  end
end
