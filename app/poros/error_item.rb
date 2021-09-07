class ErrorItem
  attr_reader :error_message

  def initialize(error_message)
    # require "pry"; binding.pry
    @id = 1
    @error_message = error_message
  end
end
