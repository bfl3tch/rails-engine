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

  def self.merchant_revenue(merchant_id)
     joins(:transactions)
    .joins(:invoice_items)
    .joins(:invoices)
    .select("merchants.id as id, merchants.name as name, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .where("merchants.id = ?", "#{merchant_id}")
    .group(:name, :id)
  end

  def self.most_revenue
     joins(:transactions)
    .joins(:invoice_items)
    .select("merchants.id as id, merchants.name as name, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .group(:name, :id)
    .order(revenue: :desc)
    .where("invoices.status = ?", 'shipped')
    .where("transactions.result = ?", 'success')
  end
end
