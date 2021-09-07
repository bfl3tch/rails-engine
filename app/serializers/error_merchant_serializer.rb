class ErrorMerchantSerializer
  attr_reader :error_message

  def initialize(error_message)
    @error_message = error_message
  end
end
