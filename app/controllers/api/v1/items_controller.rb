class Api::V1::ItemsController < ApplicationController
  before_action :set_item, only: [:show, :destroy, :update]
  before_action :update_item, only: [:update]
  before_action :create_item, only: [:create]

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

  def create
    json_response(ItemSerializer.new(@new_item), :created) if @new_item.save
    json_response(ErrorItemSerializer.new(@error_item), :bad_request) if !@new_item.save
  end

  def update
    @item ? json_response(ItemSerializer.new(@item), :created) : json_response(ErrorItemSerializer.new(@error_item), :not_found)
    # json_response(ItemSerializer.new(@item), :created) :  if @item
    # json_response(ErrorItemSerializer.new(@error_item), :not_found)
  end

  def destroy
    json_response(ItemSerializer.new(@item.delete), :ok) if @item
    json_response(ErrorItemSerializer.new(@error_item), :not_found) if @item.nil?
  end

  private

  def set_item
    @item = Item.find_by_id(params[:id])
    @error_item = ErrorItem.new("No item found with that ID") if @item.nil?
  end

  def create_item
    @new_item = Item.create(item_params)
    @error_item = ErrorItem.new("Bad or missing attributes") if !@new_item.save
  end

  def update_item
    # require "pry"; binding.pry
    @good_merchant = Merchant.where(id: item_params['merchant_id'])
    # require "pry"; binding.pry
    if @item && @good_merchant
      @item.update(item_params)
    # elsif @item && !item_params['merchant_id']
  elsif @item && @good_merchant.empty?
      @item.update(item_params)
    else
      @error_item = ErrorItem.new("No item found with that ID") if @item.nil?
      @error_item = ErrorItem.new("Merchant ID must match an existing Merchant") if @good_merchant.empty?
    end
  end

  def item_params
    params.require(:item).permit(:id, :name, :description, :unit_price, :merchant_id)
  end
end
