class Api::V1::Items::FindController < ApplicationController
  before_action :set_item, only: [:index]

  def index
    json_response(ItemSerializer.new(@item), status) if @item
    json_response(ErrorSerializer.new(@error_item), :bad_request) if @error_item && @item.nil?
    json_response(UnfoundItemSerializer.new(@bad_item), :bad_request) if @item.nil? && @error_item.nil?
  end

  private

  def set_item
    name = params[:name] if (params[:name] && params[:name] != "")
    min = params[:min_price].to_i if params[:min_price]
    max = params[:max_price].to_i if params[:max_price]

    @bad_item = ErrorItem.new("No items in that price range") if (min && min > 10000)
    @error_item = ErrorItem.new("Price Below Zero") if (max && max < 0)
    @error_item = ErrorItem.new("Price Below Zero") if (min && min < 0)
    @error_item = ErrorItem.new("Unable to process request") if name && (min.present? || max.present?)
    @error_item = ErrorItem.new("No match for that name") if (name && ItemsFacade.item_search(name).nil?)

    @item = ItemsFacade.item_search(name) if name && (min.nil? && max.nil?)
    @item = ItemsFacade.both_price_search(min, max) if (min && max) && name.nil? && ((min >= 0) && (max >= 0))
    @item = ItemsFacade.min_price_search(min) if min && (name.nil? && max.nil? && (min >= 0))
    @item = ItemsFacade.max_price_search(max) if max && (name.nil? && min.nil? && (max >= 0))
  end
end
