# ruby-cx-lib
Ruby CoinsPro API Library

## Getting Started
You may download the Coins Pro API documentation [here](https://s3-ap-northeast-1.amazonaws.com/coins-staging-static-uploads/uploads/files/Coins+Pro+API.pdf). Access to the API is available only for customers who have a Coins Pro account.  

For the authentication credentials, please email coinspro.support@coins.ph using the email you're using for Coins Pro together with your **PGP Public Key**. This way, they can provide the API credentials in a secure manner.

## Usage
Require library.

```ruby
require "cx"
```

Create an instance of CX.

```ruby
CX cx = new CX(CX.production);
```

|Environment   |URL                                          |
|--------------|---------------------------------------------|
|CX.production |wss://api-cx.coins.asia/ws-api/              |
|CX.staging    |wss://api-cx.staging.coins.technology/ws-api/|


Subscribe to response or events.

```ruby
cx.on :get_prodcuts do |e|
  #Do something with e.products
end
```

Send request.

```ruby
cx.get_products
```

|Response/Event             |Description                                                                                                                                                                  | 
|---------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|:get_products              |Returns a list of available **products** from the API.                                                                                                                       |
|:get_instruments           |Returns a list of available **instruments** from the API.                                                                                                                    |
|:web_authenticate_user     |Returns if session is **authenticated**, **session_token**, **user_id**, and **error_msg**.                                                                                                   |
|:get_user_accounts         |Returns a list of **account_ids** for the current user.                                                                                                                          |
|:get_account_transactions  |Retruns a list of recent **transactions** from your account.                                                                                                                 |
|:get_account_position      |Returns a list of account **positions**(Balances) on a specific account.                                                                                                      |
|:get_account_trades        |Retruns a list of account **trades** history for a specific account.                                                                                                           |
|:send_order                |Retruns **status**, **error_msg**, and **order_id**.                                                                                                                      |
|:cancel_order              |Returns **status**, **error_msg**, **error_code**, and **detail**.                                                                                                         |
|:get_order_status          |Reutrns the **order_status**(current operating status of an order) submitted to Order Management System.                                                                      |
|:get_order_fee             |Returns the estimate of the **order_fee** and **product_id** for a specific order and order type.                                                                              |
|:get_order_history         |Returns the list of of the last 100 **orders** placed on your account.                                                                                                       |
|:get_open_orders           |Returns the list of Open **orders** for specified account of current user.                                                                                                   |
|:create_withdraw_ticket    |Returns **result**, **error_msg**, and **error_code**.                                                                                                                     |
|:subscribe_level_1         |Returns level 1 **market_data**.                                                                                                                                                |
|:level_1_update_event      |Returns level 1 **market_data**.                                                                                                                                                |
|:unsubscribe_level_1       |Returns **result**, **error_msg**, **error_code**, and **detail**.                                                                                                         |
|:subscribe_level_2         |Returns level 2 **market_data**.                                                                                                                                        |
|:level_2_update_event      |Returns level 2 **market_data**.                                                                                                                                        |
|:unsubscribe_level_2       |Returns **result**, **error_msg**, **error_code**, and **detail**.                                                                                                         |
|:subscribe_trades          |Returns list of the latest public **market_trades** for the specific instrument.                                                                                              |
|:trade_data_update_event   |Returns list of the latest public **market_trades** for the specific instrument.                                                                                              |
|:unsubscribe_trades        |Returns **result**, **error_msg**, **error_code**, and **detail**.                                                                                                         |
|:subscribe_account_events  |Returns **result**.                                                                                                                                                          |
|:pending_deposit_update    |Returns **account_id**, **asset_id**, **total_pending_deposit_value**.                                                                                                            |
|:account_position_event    |Returns account **position** any time the balance of your account changes.                                                                                                    |
|:order_state_event         |Returns **order_status** events any time the status of an order on your account changes.                                                                                      |
|:order_trade_event         |Returns account **trade** any time one of your orders results in a trade.                                                                                                     |
|:new_order_reject_event    |Returns **account_id**, **client_order_id**, **status**, and **reject_reason** if your order is rejected.                                                                        |
|:cancel_order_reject_event |Returns **account_id**, **order_id**,  **order_revision**, **order_type**, **instrument_id**, **status**, and **RejectReason** if your attempt to cancel an order is unsuccessful.|
|:market_state_update       |Returns **exchange_id**, **venue_adapter_id**, **venue_instrument_id**, **action**, **previous_status**, **new_status**, and **exchange_date_time**.                                  |


|Request(*Italic* parameters are optional.)																	|Details                                                                                                 | 
|-----------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------|
|get_products(*sequence_number*)                        													|Sends a request to get available products from the API.                                                 |
|get_instruments(*sequence_number*)																			|Sends a request to get available instruments from the API.                                              |
|web_authenticate_user(username, password, *sequence_number*)												|Sends a request to authenticate.                                                                        |
|get_user_accounts(*sequence_number*)																		|Sends a request to get user accounts.                                                                   |
|get_account_transactions(account_id, *sequence_number*)													|Sends a request to get transaction from your account.                                                   | 
|get_account_position(account_id, *sequence_number*)														|Sends a request to get account positions(balance) on a specific account.                                |
|get_account_trades(account_id, *sequence_number*)															|Sends a request to get account trades for a specific account.                                           |
|send_order(*sequence_number*)																				|Sends a new order into the API.                                                                         |
|cancel_order(account_id, client_order_id, order_id, *sequence_number*)										|Sends a request to cancel an open order.                                                                |  
|get_order_status(account_id, order_id, *sequence_number*)													|Sends a request get the current operating status of an order.                                           |
|get_order_fee(account_id, instrument_id, product_id, amount, order_type, maker_taker, *sequence_number*)	|Sends a request to get the estimate of the fee for a specific order and order type.                     |
|get_order_history(account_id, *sequence_number*)															|Sends a request to get the list of orders placed on your account.                                       |
|get_open_orders(account_id, *sequence_number*)																|Sends a request to get the list of Open Orders for specified account of current user.                   |
|create_withdraw_ticket(product_id, account_id, amount *sequence_number*)									|Sends a request to creates a withdrawal ticket to send funds from Coins Pro to the user’s Coins wallet. |                            |
|subscribe_level_1(instrument_id, *sequence_number*)														|Sends a request to subscribe to level 1 market data.                                                    |
|unsubscribe_trades(instrument_id, *sequence_number*)														|Sends a request to unsubscribe to level 1 market data.                                                  |
|subscribe_level_2(instrument_id, depth, *sequence_number*)													|Sends a request to subscribe to level 2 market data.                                                    |
|unsubscribe_level_2(instrument_id, *sequence_number*)														|Sends a request to unsubscribe to level 2 market data.                                                  |
|subscribe_trades(instrument_id, include_last_count, *sequence_number*)										|Sends a request to subscribe to market trades.                                                          |
|unsubscribe_trades(instrument_id, *sequence_number*)														|Sends a request to unsubscribe to market trades.                                                        |
|subscribe_account_events(account_id, *sequence_number*)													|Sends request to account-level events, such as orders, trades, deposits and withdraws.                  |


## Examples

```ruby
require 'eventmachine'

require_relative "../lib/cx" # require library

EM.run do
  # create an instance
  cx = CX.new(CX.production) 

  # subscribe to get_products response
  cx.on :get_products do |e|  
    p e.sequence_number
	  e.products.each do |product| # handle e.products
	    printf("%-2s", product.product_id)
	    printf("%-4s", product.product)
	    printf("%-20s", product.product_full_name)
	    printf("%-20s", product.product_type)
	    printf("%-2s", product.decimal_places)
	    print "\n"
	  end
  end

  # send request to get_products
  cx.get_products
end
```
