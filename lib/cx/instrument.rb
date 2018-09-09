class Instrument
  attr_reader :intrument_id, :symbol, :product_1, :product_1_symbol, :product_2, :product_2_symbol, :instrument_type
  def initialize(instrument_id, symbol, product_1, product_1_symbol, product_2, product_2_symbol, instrument_type)
    @instrument_id = instrument_id
    @symbol = symbol
    @product_1 = product_1
    @product_1_symbol = product_1_symbol
    @product_2 = product_2
    @product_2_symbol = product_2_symbol
    @instrument_type = instrument_type
  end
end
