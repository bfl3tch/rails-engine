class Api::V1::MerchantsController < ApplicationController
  before_action :set_merchant, only: [:show]
  include Response
  include ExceptionHandler

  def index
    per_page = MerchantsFacade.per_page(params[:per_page])
    page = MerchantsFacade.page(params[:page])
    merchants = MerchantsFacade.fetch_requested_merchants(per_page, page)
    json_response(MerchantSerializer.new(merchants), status)
  end

  def show
    json_response(MerchantSerializer.new(@merchant), status)
    raise ActiveRecord::RecordNotFound if @merchant.nil?
  end

  private

  def set_merchant
    @merchant = Merchant.find_by_id(params[:id])
  end
end
