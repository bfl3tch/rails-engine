module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end
end


# # merchants = Merchant.all.limit(per_page).offset(page)
# merchants = MerchantsFacade.fetch_requested_merchants(per_page, page)
# object = MerchantSerializer.new(merchants)
# json_response(object, status)
