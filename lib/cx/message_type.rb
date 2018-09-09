class MessageType
  def self.request; 0 end
  def self.response; 1 end
  def self.subscribe; 2 end
  def self.event; 3 end
  def self.unsubscribe; 4 end
  def self.error; 5 end
end
