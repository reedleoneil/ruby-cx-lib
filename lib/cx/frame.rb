class Frame
<<<<<<< HEAD
  attr_accessor :message_type, :sequence_number, :function_name, :payload
=======
  attr_reader :MessageType, :SequenceNumber, :FunctionName, :Payload
>>>>>>> e269064753cceb70b558adfc96e2e822342c114d
  def initialize(m, i, n, o)
    @MessageType = m
    @SequenceNumber = i
    @FunctionName = n
    @Payload = o
  end

  def self.serialize(frame)
    return {'m' => frame.message_type, 'i' => frame.sequence_number, 'n' => frame.function_name, 'o' => frame.payload.to_json}.to_json
  end

  def self.deserialize(json)
    hash = JSON.parse(json)
    frame = Frame.new(hash["m"], hash["i"], hash["n"], hash["o"])
    frame.payload = JSON.parse(frame.payload)
    return frame
  end
end
