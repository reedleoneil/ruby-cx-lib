class Frame
  attr_reader :message_type, :sequence_number, :function_name, :payload
  def initialize(m, i, n, o)
    @message_type = m
    @sequence_number = i
    @function_name = n
    @payload = o
  end
end
