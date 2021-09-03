FactoryBot.define do
  factory :item do
    name { "MyString" }
    description { "MyString" }
    unit_price { 1.5 }
    merchant_id { nil }
  end
end
