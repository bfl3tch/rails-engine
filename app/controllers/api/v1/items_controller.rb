class Api::V1::ItemsController < ApplicationController
  before_action :set_item, only: [:show]

  def index
    per_page = ItemsFacade.per_page(params[:per_page])
    page = ItemsFacade.page(params[:page])
    items = ItemsFacade.fetch_requested_items(per_page, page)
    json_response(ItemSerializer.new(items), status)
  end

  def show
    json_response(ItemSerializer.new(@item), status) if @item
    json_response(ErrorItemSerializer.new(@error_item), :not_found) if @item.nil?
  end

  private

  def set_item
    @item = Item.find_by_id(params[:id])
    @error_item = ErrorItem.new("No item found with that ID") if @item.nil?
  end
end
