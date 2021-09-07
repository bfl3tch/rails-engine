class MerchantsFacade
  def self.per_page(params)
    params.nil? ? 20 : params.to_i
  end

  def self.page(params)
    (params.nil? || params.to_i <= 0) ? 0 : (params.to_i - 1) * 20
  end

  def self.fetch_requested_merchants(per_page, page)
    Merchant.fetch_requested_merchants(per_page, page)
  end
end
