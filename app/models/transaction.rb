class Transaction < ApplicationRecord
  belongs_to :invoice
  has_many :customers, through: :invoice

  validates :credit_card_number, presence: true
  validates :credit_card_expiration_date, presence: true
  validates :result, presence: true
end
