class Api::V1::MerchantsController < ApplicationController
  def index
    per_page = params[:per_page].nil? ? 20 : params[:per_page].to_i
    page = (params[:page].nil? || params[:page].to_i <= 0) ? 0 : (params[:page].to_i - 1) * 20
    merchants = Merchant.all.limit(per_page).offset(page)
    render json: MerchantSerializer.new(merchants)
  end
end
