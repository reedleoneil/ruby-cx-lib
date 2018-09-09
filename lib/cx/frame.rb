class Frame
  attr_accessor :message_type, :sequence_number, :function_name, :payload

  def initialize(m, i, n, o)
    @message_type = m
    @sequence_number = i
    @function_name = n
    @payload = o
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
