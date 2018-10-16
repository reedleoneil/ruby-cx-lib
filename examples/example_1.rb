require 'eventmachine'

require_relative "../lib/cx"

EM.run do
  cx = CX.new(CX.production)
  cx.get_products()
  cx.get_instruments()
  cx.web_authenticate_user("", "")
  cx.get_user_accounts

  cx.on :get_products do |e|
    p e.sequence_number
	e.products.each do |product|
	    printf("%-2s", product.product_id)
	    printf("%-4s", product.product)
	    printf("%-20s", product.product_full_name)
	    printf("%-20s", product.product_type)
		printf("%-2s", product.decimal_places)
		print "\n"
	end
  end

  cx.on :get_instruments do |e|
    p e.sequence_number
	e.instruments.each do |instrument|
		printf("%-3s", instrument.instrument_id)
		printf("%-4s", instrument.symbol)
		printf("%-2s", instrument.product1)
		printf("%-4s", instrument.product1_symbol)
		printf("%-2s", instrument.product2)
		printf("%-4s", instrument.product2_symbol)
		printf("%-10s", instrument.instrument_type)
		print "\n"
	end
  end

  cx.on :web_authenticate_user do |e|
	p e.sequence_number
	p e.authenticated
	p e.session_token
	p e.user_id
	p e.errormsg
  end

  cx.on :get_user_accounts do |e|
	p e.sequence_number
	e.account_ids.each do |account_id|
	  p account_id
	end
  end
end
