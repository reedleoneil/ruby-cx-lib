class Frame
  attr_reader :MessageType, :SequenceNumber, :FunctionName, :Payload
  def initialize(m, i, n, o)
    @MessageType = m
    @SequenceNumber = i
    @FunctionName = n
    @Payload = o
  end
end
