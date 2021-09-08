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
end
