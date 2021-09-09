class Api::V1::Revenue::MerchantsController < ApplicationController
  before_action :get_revenue, only: [:index]
  before_action :set_merchant, only: [:show]

  def index
    json_response(MerchantNameRevenueSerializer.new(@results)) if @results
    json_response(ErrorSerializer.new(@error_merchant), :bad_request) if @results.nil?
  end

  def show
    json_response(MerchantRevenueSerializer.new(@merchant)) if @merchant
  end

  private

  def get_revenue
    limit = params[:quantity].to_i if params[:quantity]
    search = limit if (limit && limit > 0)
    @results = MerchantsFacade.most_revenue_ranked(search) if search
    @error_merchant = ErrorMerchant.new("Quantity Required") if @results.nil?
  end

  def set_merchant
    @merchant = Merchant.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    @error_merchant = ErrorMerchant.new("No merchant found with that ID") if @merchant.nil?
    json_response(ErrorMerchantSerializer.new(@error_merchant), :not_found) if @error_merchant
  end
end
