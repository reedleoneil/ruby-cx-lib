class Instrument
  attr_reader :InstrumentId, :Symbol, :Product1, :Product1Symbol, :Product2, :Product2Symbol, :InstrumentType
  def initialize(instrument_id, symbol, product_1, product_1_symbol, product_2, product_2_symbol, instrument_type)
    @InstrumentId = instrument_id
    @Symbol = symbol
    @Product1 = product_1
    @Product1Symbol = product_1_symbol
    @Product2 = product_2
    @Product2Symbol = product_2_symbol
    @InstrumentType = instrument_type
  end
end
