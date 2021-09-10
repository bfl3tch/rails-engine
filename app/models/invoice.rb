class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :transactions, dependent: :destroy
  has_many :merchants, through: :items

  validates :status, presence: true


  def self.unshipped_potential_revenue(quantity)
    joins(:invoice_items)
    .joins(:transactions)
    .select("invoices.id as id, sum(invoice_items.quantity * invoice_items.unit_price) as potential_revenue")
    .where('transactions.result = ?', 'success')
    .where.not(status: 'shipped')
    .group(:id)
    .order("potential_revenue DESC")
    .limit(quantity)
  end
end
