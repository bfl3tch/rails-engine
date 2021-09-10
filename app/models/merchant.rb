class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates :name, presence: true

  def self.fetch_requested_merchants(per_page, page)
    limit(per_page).offset(page)
  end

  def self.fetch_merchant_items(merchant)
    find_by_id(merchant.id).items if merchant
  end

  def self.find_by_name(search)
    where("lower(name) ILIKE ?", "%#{search.downcase}%").order(:name)
  end

  def merchant_revenue
    self.invoices.joins(:invoice_items)
    .joins(:transactions)
    .select("sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .where("transactions.result = ?", 'success')
    .where("invoices.status = ?", 'shipped')
    .sum("invoice_items.quantity * invoice_items.unit_price")
  end

  def self.most_revenue(quantity)
    select("merchants.name, merchants.id, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .joins(invoices: :invoice_items)
    .joins(invoices: :transactions)
    .where("transactions.result = ?", 'success')
    .where("invoices.status = ?", 'shipped')
    .group(:name, :id)
    .order(revenue: :desc)
    .limit(quantity)
  end
end
