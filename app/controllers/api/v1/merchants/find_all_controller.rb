class Api::V1::Merchants::FindAllController < ApplicationController
  before_action :set_merchant, only: [:index]

  def index
    json_response(MerchantSerializer.new(@merchant)) if @merchant
  end

  private

  def set_merchant
    name = params[:name] if (params[:name] && params[:name] != "")
    @merchant = MerchantsFacade.search_by_name(name) if name
  end
end
