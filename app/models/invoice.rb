class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant

  enum status: { shipped: 0, packaged: 1, returned: 2 }

end
