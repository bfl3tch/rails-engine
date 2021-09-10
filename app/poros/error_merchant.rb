class ErrorMerchant
  attr_reader :error_message

  def initialize(error_message)
    # @id = 1
    @error_message = error_message
  end
end
