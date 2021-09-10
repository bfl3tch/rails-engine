class ErrorSerializer
  attr_reader :error, :data

  def initialize(error)
    @error = error
    @data = {}
  end
end
