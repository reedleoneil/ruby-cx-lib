require 'eventmachine'

require_relative "../lib/cx"

EM.run do
  cx = CX.new(CX.production)
  cx.get_products(0)
  cx.get_instruments(0)
end
