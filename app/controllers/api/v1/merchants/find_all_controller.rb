class Api::V1::Merchants::FindAllController < ApplicationController
  before_action :set_merchant, only: [:index]

  def index
    @merchant ? json_response(MerchantSerializer.new(@merchant)) : json_response(ErrorMerchantSerializer.new(@error_merchant), :bad_request)
  end

  private

  def set_merchant
    name = params[:name] if (params[:name] && params[:name] != "")
    @merchant = MerchantsFacade.search_by_name(name) if name
    @error_merchant = ErrorMerchant.new("Need a valid name") if @merchant.nil?
  end
end
