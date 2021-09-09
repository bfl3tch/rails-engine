class MerchantRevenueSerializer
  include JSONAPI::Serializer
  attributes :revenue do |merchant|
    merchant.merchant_revenue
  end
end
