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

  def self.search_by_name(search)
    Merchant.find_by_name(search)
  end

  def self.most_revenue_ranked(search)
    Merchant.most_revenue(search)
  end

end
