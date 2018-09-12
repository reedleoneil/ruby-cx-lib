require "faye/websocket"
require "json"
require "ostruct"

require_relative "cx/message_type.rb"
require_relative "cx/frame.rb"
require_relative "cx/instrument.rb"
require_relative "cx/product.rb"

class CX
  attr_reader :is_connected, :is_authenticated
  def self.production; "wss://api-cx.coins.asia/ws-api/" end
  def self.staging; "wss://api-cx.staging.coins.technology/ws-api/" end

  def initialize(url)
    @on_get_products = []
    @on_get_instruments = []
    connect_to_api(url)
  end

  def on(event, &proc)
    case event
    when :get_products
      @on_get_products.push(proc)
    when :get_instruments
      @on_get_instruments.push(proc)
    end
  end

  def get_products(sequence_number = 0)
    payload = { "OMSId" => 1 }
    frame = Frame.new(MessageType.request, sequence_number, "GetProducts", payload)
    @ws.send(Frame.serialize(frame))
  end

  def get_instruments(sequence_number = 0)
    payload = { "OMSId" => 1 }
    frame = Frame.new(MessageType.request, sequence_number, "GetInstruments", payload)
    @ws.send(Frame.serialize(frame))
  end

  def web_authenticate_user(username, password, sequence_number = 0)
    payload = { "UserName" => username, "Password" => password }
    frame = Frame.new(MessageType.request, sequence_number, "WebAuthenticateUser", payload)
    @ws.send(Frame.serialize(frame))
  end

  def get_user_accounts(sequence_number = 0)
    frame = Frame.new(MessageType.request, sequence_number, "GetUserAccounts", {})
    @ws.send(Frame.serialize(frame))
  end

  def get_account_transactions(account_id, depth, sequence_number = 0)
    payload = { "OMSId" => 1, "AccountId" => account_id, "Depth" => depth }
    frame = frame = Frame.new(MessageType.request, sequence_number, "GetAccountTransactions", payload)
    @ws.send(Frame.serialize(frame))
  end

  def get_account_positions(account_id, sequence_number = 0)
    payload = { "OMSId" => 1, "AccountId" => account_id }
    frame = Frame.new(MessageType.request, sequence_number, "GetAccountPositions", payload)
    @ws.send(Frame.serialize(frame))
  end

  def get_account_trades(account_id, count, start_index, sequence_number = 0)
    payload = { "OMSId" => 1, "AccountId" => account_id, "Count" => count, "StartIndex" => start_index }
    frame = Frame.new(MessageType.request, sequence_number, "GetAccountTrades", payload)
    @ws.send(Frame.serialize(frame))
  end

  def send_order(account_id, client_order_id, quantity, display_quantity, user_display_quantity, limit_price, order_id_oco, order_type, peg_price_type, instrument_id, trailing_amount, limit_offest, side, stop_price, time_in_force, sequence_number = 0)
    payload = {
      "OMSId" => 1,
      "AccountId" => account_id,
      "ClientOrderId" => client_order_id,
      "Quantity" => quantity,
      "DisplayQuantity" => display_quantity,
      "UseDisplayQuantity" => use_display_quantity,
      "LimitPrice" => limit_price,
      "OrderIdOCO" => order_id_oco,
      "OrderType" => order_type,
      "PegPriceType" => peg_price_type,
      "InstrumentId" => instrument_id,
      "LimitOffset" => limit_offset,
      "Side" => side,
      "StopPrice" => stop_price,
      "TimeInForce" => time_in_force
    }
    frame = Frame.new(MessageType.request, sequence_number, "SendOrder", payload)
    @ws.send(Frame.serialize(frame))
  end

  def cancel_order(account_id, order_id, sequence_number = 0)
    payload = { "OMSId" => 1, "AccountId" => account_id, "OrderId" => order_id }
    frame = Frame.new(MessageType.request, sequence_number, "CancelOrder", payload)
    @ws.send(Frame.serialize(frame))
  end

  def get_order_status(account_id, order_id, sequence_number = 0)
    payload = { "OMSId" => 1, "AccountId" => account_id, "OrderId" => order_id }
    frame = Frame.new(MessageType.request, sequence_number, "GetOrderStatus", payload)
    @ws.send(Frame.serialize(frame))
  end

  def get_order_fee(account_id, instrument_id, product_id, amount, order_type, maker_taker, sequence_number = 0)
    payload = {
      "OMSId" => 1,
      "AccountId" => account_id,
      "InstrumentId" => instrument_id,
      "ProductId" => product_id,
      "Amount" => amount,
      "OrderType" => order_type,
      "MakerTaker" => maker_taker
    }
    frame = Frame.new(MessageType.request, sequence_number, "GetOrderFee", payload)
    @ws.send(Frame.serialize(frame))
  end

  def get_order_history(account_id, sequence_number = 0)
    payload = { "OMSId" => 1, "AccountId" => account_id }
    frame = Frame.new(MessageType.request, sequence_number, "GetOrderHistory", payload)
    @ws.send(Frame.serialize(frame))
  end

  def get_open_orders(account_id, sequence_number = 0)
    payload = { "OMSId" => 1, "AccountId" => account_id }
    frame = Frame.new(MessageType.request, sequence_number, "GetOpenOrders", payload)
    @ws.send(Frame.serialize(frame))
  end

  def create_withdraw_ticket(product_id, account_id, amount, sequence_number = 0)
    payload = { "OMSId" => 1, "ProductId" => product_id, "AccountId" => account_id, "Amount" => amount }
    frame = Frame.new(MessageType.request, sequence_number, "CreateWithdrawTicket", payload)
    @ws.send(Frame.serialize(frame))
  end

  def subscribe_level_1(instrument_id, sequence_number = 0)
    payload = { "OMSId" => 1, "InstrumentId" => instrument_id }
    frame = Frame.new(MessageType.request, sequence_number, "SubscribeLevel1", payload)
    @ws.send(Frame.serialize(frame))
  end

  def unsubscribe_level_1(instrument_id, sequence_number = 0)
    payload = { "OMSId" => 1, "InstrumentId" => instrument_id }
    frame = Frame.new(MessageType.request, sequence_number, "UnsubscribeLevel1", payload)
    @ws.send(Frame.serialize(frame))
  end

  def subscribe_level_2(instrument_id, depth, sequence_number = 0)
    payload = { "OMSId" => 1, "InstrumentId" => instrument_id, "Depth" => depth }
    frame = Frame.new(MessageType.request, sequence_number, "SubscribeLevel2", payload)
    @ws.send(Frame.serialize(frame))
  end

  def unsubscribe_level_2(instrument_id, sequence_number = 0)
    payload = { "OMSId" => 1, "InstrumentId" => instrument_id }
    frame = Frame.new(MessageType.request, sequence_number, "UnsubscribeLevel2", payload)
    @ws.send(Frame.serialize(frame))
  end

  def subscribe_trades(instrument_id, include_last_count, sequence_number = 0)
    payload = { "OMSId" => 1, "InstrumentId" => instrument_id, "IncludeLastCount" => include_last_count }
    frame = Frame.new(MessageType.request, sequence_number, "SubscribeTrades", payload)
    @ws.send(Frame.serialize(frame))
  end

  def unsubscribe_trades(instrument_id, sequence_number = 0)
    payload = { "OMSId" => 1, "InstrumentId" => instrument_id }
    frame = Frame.new(MessageType.request, sequence_number, "UnsubscribeTrades", payload)
    @ws.send(Frame.serialize(frame))
  end

  def subscribe_account_events(account_id, sequence_number = 0)
    payload = { "OMSId" => 1, "AccountId" => account_id }
    frame = Frame.new(MessageType.request, sequence_number, "SubscribeAccountEvents", payload)
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
      case frame.message_type
      when MessageType.reply
        case frame.function_name
        when "GetProducts"
          @on_get_products.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "GetInstruments"
          @on_get_instruments.each { |proc| proc.call() }
        end
      when MessageType.event
      when MessageType.error
      end
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
