class Frame
  attr_accessor :message_type, :sequence_number, :function_name, :payload

  def self.serialize(frame)
    return {'m' => frame.message_type, 'i' => frame.sequence_number, 'n' => frame.function_name, 'o' => frame.payload.to_json}.to_json
  end

  def self.deserialize(json)
    hash = JSON.parse(json)
    frame = Frame.new
    frame.message_type = hash["m"]
    frame.sequence_number = hash["i"]
    frame.function_name = hash["n"]
    frame.payload = hash["o"]
    frame.payload = JSON.parse(frame.payload)
    return frame
  end
end
