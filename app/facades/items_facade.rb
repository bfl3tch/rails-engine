class ItemsFacade
  def self.per_page(params)
    @@perpage = params.nil? ? 20 : params.to_i
  end

  def self.page(params)
    (params.nil? || params.to_i <= 0) ? 0 : (params.to_i - 1) * @@perpage
  end

  def self.fetch_requested_items(per_page, page)
    Item.fetch_requested_items(per_page, page)
  end

  def self.item_search(name)
    Item.case_insensitive_search(name)
  end

  def self.min_price_search(price)
    Item.search_via_min_price(price)
  end

  def self.max_price_search(price)
    Item.search_via_max_price(price)
  end

  def self.both_price_search(min, max)
    Item.search_via_both_prices(min, max)
  end
end
