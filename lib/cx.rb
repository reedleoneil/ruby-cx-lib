require "faye/websocket"
require "json"

require_relative "cx/message_type.rb"
require_relative "cx/frame.rb"
require_relative "cx/instrument.rb"
require_relative "cx/product.rb"

class CX
  attr_reader :is_connected, :is_authenticated
  def self.production; "wss://api-cx.coins.asia/ws-api/" end
  def self.staging; "wss://api-cx.staging.coins.technology/ws-api/" end

  def initialize(url)
    connect_to_api(url)
  end

  def get_products(sequence_number = 0)
    frame = Frame.new
    frame.message_type = MessageType.request
    frame.sequence_number = sequence_number
    frame.function_name = "GetProducts"
    frame.payload = { "OMSId" => 1 }
    @ws.send(Frame.serialize(frame))
  end

  def get_instruments(sequence_number = 0)
    frame = Frame.new
    frame.message_type = MessageType.request
    frame.sequence_number = sequence_number
    frame.function_name = "GetInstruments"
    frame.payload = { "OMSId" => 1 }
    @ws.send(Frame.serialize(frame))
  end

  def web_authenticate_user(username, password, sequence_number = 0)
    frame = Frame.new
    frame.message_type = MessageType.request
    frame.sequence_number = sequence_number
    frame.function_name = "WebAuthenticateUser"
    frame.payload = { "UserName" => username, "Password" => password }
    @ws.send(Frame.serialize(frame))
  end

  def get_user_accounts(sequence_number = 0)
    frame = Frame.new
    frame.message_type = MessageType.request
    frame.sequence_number = sequence_number
    frame.function_name = "GetUserAccounts"
    frame.payload = { }
    @ws.send(Frame.serialize(frame))
  end

  def get_user_accounts(sequence_number = 0)
    frame = Frame.new
    frame.message_type = MessageType.request
    frame.sequence_number = sequence_number
    frame.function_name = "GetUserAccounts"
    frame.payload = { }
    @ws.send(Frame.serialize(frame))
  end

  def get_account_transactions(account_id, depth, sequence_number = 0)
    frame = Frame.new
    frame.message_type = MessageType.request
    frame.sequence_number = sequence_number
    frame.function_name = "GetAccountTransactions"
    frame.payload = { "OMSId" => 1, "AccountId" => account_id, "Depth" => depth }
    @ws.send(Frame.serialize(frame))
  end

  def get_account_positions(account_id, sequence_number = 0)
    frame = Frame.new
    frame.message_type = MessageType.request
    frame.sequence_number = sequence_number
    frame.function_name = "GetAccountPositions"
    frame.payload = { "OMSId" => 1, "AccountId" => account_id }
    @ws.send(Frame.serialize(frame))
  end

  def get_account_trades(account_id, count, start_index, sequence_number = 0)
    frame = Frame.new
    frame.message_type = MessageType.request
    frame.sequence_number = sequence_number
    frame.function_name = "GetAccountTrades"
    frame.payload = { "OMSId" => 1, "AccountId" => account_id, "Count" => count, "StartIndex" => start_index }
    @ws.send(Frame.serialize(frame))
  end

  def send_order(account_id, client_order_id, quantity, display_quantity, user_display_quantity, limit_price, order_id_oco, order_type, peg_price_type, instrument_id, trailing_amount, limit_offest, side, stop_price, time_in_force, sequence_number = 0)
    frame = Frame.new
    frame.message_type = MessageType.request
    frame.sequence_number = sequence_number
    frame.function_name = "SendOrder"
    frame.payload = { "OMSId" => 1, "AccountId" => account_id, "ClientOrderId" => client_order_id, "Quantity" => quantity, "DisplayQuantity" => display_quantity, "UseDisplayQuantity" => use_display_quantity, "LimitPrice" => limit_price, "OrderIdOCO" => order_id_oco, "OrderType" => order_type, "PegPriceType" => peg_price_type, "InstrumentId" => instrument_id, "LimitOffset" => limit_offset, "Side" => side, "StopPrice" => stop_price, "TimeInForce" => time_in_force }
    @ws.send(Frame.serialize(frame))
  end

  def cancel_order(account_id, order_id, sequence_number = 0)
    frame = Frame.new
    frame.message_type = MessageType.request
    frame.sequence_number = sequence_number
    frame.function_name = "CancelOrder"
    frame.payload = { "OMSId" => 1, "AccountId" => account_id, "OrderId" => order_id }
    @ws.send(Frame.serialize(frame))
  end

  def get_order_status(account_id, order_id, sequence_number = 0)
    frame = Frame.new
    frame.message_type = MessageType.request
    frame.sequence_number = sequence_number
    frame.function_name = "GetOrderStatus"
    frame.payload = { "OMSId" => 1, "AccountId" => account_id, "OrderId" => order_id }
    @ws.send(Frame.serialize(frame))
  end

  def get_order_fee(account_id, instrument_id, product_id, amount, order_type, maker_taker, sequence_number = 0)
    frame = Frame.new
    frame.message_type = MessageType.request
    frame.sequence_number = sequence_number
    frame.function_name = "GetOrderFee"
    frame.payload = { "OMSId" => 1, "AccountId" => account_id, "InstrumentId" => instrument_id, "ProductId" => product_id, "Amount" => amount, "OrderType" => order_type, "MakerTaker" => maker_taker }
    @ws.send(Frame.serialize(frame))
  end

  def get_order_history(account_id, sequence_number = 0)
    frame = Frame.new
    frame.message_type = MessageType.request
    frame.sequence_number = sequence_number
    frame.function_name = "GetOrderHistory"
    frame.payload = { "OMSId" => 1, "AccountId" => account_id }
    @ws.send(Frame.serialize(frame))
  end

  def get_open_orders(account_id, sequence_number = 0)
    frame = Frame.new
    frame.message_type = MessageType.request
    frame.sequence_number = sequence_number
    frame.function_name = "GetOpenOrders"
    frame.payload = { "OMSId" => 1, "AccountId" => account_id }
    @ws.send(Frame.serialize(frame))
  end

  def create_withdraw_ticket(product_id, account_id, amount, sequence_number = 0)
    frame = Frame.new
    frame.message_type = MessageType.request
    frame.sequence_number = sequence_number
    frame.function_name = "CreateWithdrawTicket"
    frame.payload = { "OMSId" => 1, "ProductId" => product_id, "AccountId" => account_id, "Amount" => amount }
    @ws.send(Frame.serialize(frame))
  end

  def subscribe_level_1(instrument_id, sequence_number = 0)
    frame = Frame.new
    frame.message_type = MessageType.request
    frame.sequence_number = sequence_number
    frame.function_name = "SubscribeLevel1"
    frame.payload = { "OMSId" => 1, "InstrumentId" => instrument_id }
    @ws.send(Frame.serialize(frame))
  end

  def unsubscribe_level_1(instrument_id, sequence_number = 0)
    frame = Frame.new
    frame.message_type = MessageType.request
    frame.sequence_number = sequence_number
    frame.function_name = "UnsubscribeLevel1"
    frame.payload = { "OMSId" => 1, "InstrumentId" => instrument_id }
    @ws.send(Frame.serialize(frame))
  end

  def subscribe_level_2(instrument_id, depth, sequence_number = 0)
    frame = Frame.new
    frame.message_type = MessageType.request
    frame.sequence_number = sequence_number
    frame.function_name = "SubscribeLevel2"
    frame.payload = { "OMSId" => 1, "InstrumentId" => instrument_id, "Depth" => depth }
    @ws.send(Frame.serialize(frame))
  end

  def unsubscribe_level_2(instrument_id, sequence_number = 0)
    frame = Frame.new
    frame.message_type = MessageType.request
    frame.sequence_number = sequence_number
    frame.function_name = "UnsubscribeLevel2"
    frame.payload = { "OMSId" => 1, "InstrumentId" => instrument_id }
    @ws.send(Frame.serialize(frame))
  end

  def subscribe_trades(instrument_id, include_last_count, sequence_number = 0)
    frame = Frame.new
    frame.message_type = MessageType.request
    frame.sequence_number = sequence_number
    frame.function_name = "SubscribeTrades"
    frame.payload = { "OMSId" => 1, "InstrumentId" => instrument_id, "IncludeLastCount" => include_last_count }
    @ws.send(Frame.serialize(frame))
  end

  def unsubscribe_trades(instrument_id, sequence_number = 0)
    frame = Frame.new
    frame.message_type = MessageType.request
    frame.sequence_number = sequence_number
    frame.function_name = "UnsubscribeTrades"
    frame.payload = { "OMSId" => 1, "InstrumentId" => instrument_id }
    @ws.send(Frame.serialize(frame))
  end

  def subscribe_account_events(account_id, sequence_number = 0)
    frame = Frame.new
    frame.message_type = MessageType.request
    frame.sequence_number = sequence_number
    frame.function_name = "SubscribeAccountEvents"
    frame.payload = { "OMSId" => 1, "AccountId" => account_id }
    @ws.send(Frame.serialize(frame))
  end

  private
  def connect_to_api(url)
    @ws = Faye::WebSocket::Client.new(url, nil, {ping: 15})

    @ws.on :open do |event|
      p "Websocket Open: #{url}"
      @is_connected = true
    end

    @ws.on :message do |event|
      p "Websocket Message: #{event.data}"
      frame = Frame.deserialize(event.data)
    end

    @ws.on :close do |event|
      p "Websocket Close: #{event.code} #{event.reason}"
      @is_connected = false;
      connect_to_api(url)
    end

    @ws.on :error do |event|
      p "Websocket Error: #{event.exception} #{event.message}"
    end
  end
end
