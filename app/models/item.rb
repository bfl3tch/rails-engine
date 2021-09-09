class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: true
  validates :merchant, presence: true

  def self.fetch_requested_items(per_page, page)
    limit(per_page).offset(page)
  end

  def self.fetch_item(item)
    find_by_id(item.id) if item
  end

  def self.case_insensitive_search(search)
    where("lower(name) ILIKE ?", "%#{search.downcase}%")
    .order(:name)
    .first
  end

  def self.search_via_min_price(price)
    Item.where('unit_price >= ?', "#{price}").order(:name).first
  end

  def self.search_via_max_price(price)
    Item.where('unit_price <= ?', "#{price}").order(:name).first
  end

  def self.search_via_both_prices(min, max)
    Item.where('unit_price >= ?', "#{min}")
    .where('unit_price <= ?', "#{max}").order(:name).first
  end
end
