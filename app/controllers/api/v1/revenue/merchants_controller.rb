class Api::V1::Revenue::MerchantsController < ApplicationController
  # before_action :set_merchant, only: [:show]

  def index
  #   per_page = MerchantsFacade.per_page(params[:per_page])
  #   page = MerchantsFacade.page(params[:page])
  #   merchants = MerchantsFacade.fetch_requested_merchants(per_page, page)
  #   json_response(MerchantSerializer.new(merchants), status)
  end
  #
  # def show
  #   json_response(MerchantSerializer.new(@merchant), status) if @merchant
  #   json_response(ErrorMerchantSerializer.new(@error_merchant), :not_found) if @merchant.nil?
  # end
  #
  # private
  #
  # # def set_merchant
  #   @merchant = Merchant.find_by_id(params[:id])
  #   @error_merchant = ErrorMerchant.new("No merchant found with that ID") if @merchant.nil?
  # end
end
