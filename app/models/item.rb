class Item < ApplicationRecord
  belongs_to :merchant
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: true

  def self.fetch_requested_items(per_page, page)
    Item.all.limit(per_page).offset(page)
  end

  def self.fetch_item(item)
    Item.find_by_id(item.id) if item
  end
end
