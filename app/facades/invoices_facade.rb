class InvoicesFacade
  def self.rank_by_potential_revenue(quantity)
    Invoice.unshipped_potential_revenue(quantity)
  end
end
