class Merchant < ApplicationRecord
  has_many :items
  validates :name, presence: true

  def self.fetch_requested_merchants(per_page, page)
    Merchant.all.limit(per_page).offset(page)
  end
end
