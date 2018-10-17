require "faye/websocket"
require "json"
require "ostruct"

require_relative "cx/message_type.rb"
require_relative "cx/frame.rb"
require_relative "cx/instrument.rb"
require_relative "cx/product.rb"

class CX
  attr_reader :is_connected, :is_authenticated, :session_token, :user_id, :products, :instruments, :accounts
  def self.production; "wss://api-cx.coins.asia/ws-api/" end
  def self.staging; "wss://api-cx.staging.coins.technology/ws-api/" end

  def initialize(url)
    @on_get_products = []
    @on_get_instruments = []
    @on_web_authenticate_user = []
    @on_get_user_accounts = []
    @on_get_account_transactions = []
    @on_get_account_positions = []
    @on_get_account_trades = []
    @on_send_order = []
    @on_cancel_order = []
    @on_get_order_status = []
    @on_get_order_fee = []
    @on_get_order_history = []
    @on_get_open_orders = []
    @on_create_withdraw_ticket = []
    @on_subscribe_level_1 = []
    @on_unsubscribe_level_1 = []
    @on_subscribe_level_2 = []
    @on_unsubscribe_level_2 = []
    @on_subscribe_trades = []
    @on_unsubscribe_trades = []
    @on_subscribe_account_events = []
    @level_1_update_event = []
    @level_2_update_event = []
    @trade_data_udpate_event = []
    @pending_deposit_update = []
    @account_position_event = []
    @order_state_event = []
    @order_trade_event = []
    @new_order_reject_event = []
    @cancel_order_reject_event = []
    @market_state_update = []
    
    connect_to_api(url)
  end

  def on(event, &proc)
    case event
    when :get_products
      @on_get_products.push(proc)
    when :get_instruments
      @on_get_instruments.push(proc)
    when :web_authenticate_user
      @on_web_authenticate_user.push(proc)
    when :get_user_accounts
      @on_get_user_accounts.push(proc)
    when :get_account_transactions
      @on_get_account_transactions.push(proc)
    when :get_account_positions
      @on_get_account_positions.push(proc)
    when :get_account_trades
      @on_get_account_trades.push(proc)
    when :send_order
      @on_send_order.push(proc)
    when :cancel_order
      @on_cancel_order.push(proc)
    when :get_order_status
      @on_get_order_status.push(proc)
    when :get_order_fee
      @on_get_order_fee.push(proc)
    when :get_order_history
      @on_get_order_history.push(proc)
    when :get_open_orders
      @on_get_open_orders.push(proc)
    when :create_withdraw_ticket
      @on_create_withdraw_ticket.push(proc)
    when :subscribe_level_1
      @on_subscribe_level_1.push(proc)
    when :unsubscribe_level_1
      @on_unsubscribe_level_1.push(proc)
    when :subscribe_level_2
      @on_subscribe_level_2.push(proc)
    when :unsbuscribe_level_2
      @on_unsubscribe_level_2.push(proc)
    when :subscribe_trades
      @on_subscribe_trades.push(proc)
    when :unsubscribe_trades
      @on_unsubscribe_trades.push(proc)
    when :subscribe_account_events
      @on_subscribe_account_events.push(proc)
    when :level_1_update_event
      @level_1_update_event.push(proc)
    when :level_2_update_event
      @level_2_update_event.push(proc)
    when :trade_data_update_event
      @trade_data_update_event.push(proc)
    when :pending_deposit_update
      @pending_deposit_update.push(proc)
    when :account_position_event
      @account_position_event.push(proc)
    when :order_state_event
      @order_state_event.push(proc)
    when :order_state_event
      @order_trade_event.push(proc)
    when :new_order_reject_event
      @new_order_reject_event.push(proc)
    when :cancel_order_reject_event
      @cancel_order_reject_event.push(proc)
    when :market_state_update
      @market_state_update.push(proc)
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

  def send_order(account_id, client_order_id, quantity, display_quantity, use_display_quantity, limit_price, order_id_oco, order_type, peg_price_type, instrument_id, trailing_amount, limit_offest, side, stop_price, time_in_force, sequence_number = 0)
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
          products = frame.payload.each { |hash| hash.deep_transform_keys! { |key| key.underscore } }
          event_args = { "sequence_number" => frame.sequence_number, "products" => products }
          event_args = event_args.to_ostruct.freeze
          @on_get_products.each { |proc| proc.call(event_args) }
        when "GetInstruments"
          instruments = frame.payload.each { |hash| hash.deep_transform_keys! { |key| key.underscore } }
          event_args = { "sequence_number" => frame.sequence_number, "instruments" => instruments }
          event_args = event_args.to_ostruct.freeze
          @on_get_instruments.each { |proc| proc.call(event_args) }
        when "WebAuthenticateUser"
          event_args = { "sequence_number" => frame.sequence_number }.merge(frame.payload.deep_transform_keys! { |key| key.underscore })
          event_args = event_args.to_ostruct.freeze
          @on_web_authenticate_user.each { |proc| proc.call(event_args) }
        when "GetUserAccounts"
          event_args = { "sequence_number" => frame.sequence_number, "account_ids" => frame.payload }.to_ostruct.freeze
          @on_get_user_accounts.each { |proc| proc.call(event_args) }
        when "GetAccountTransactions"
          transactions = frame.payload.each { |hash| hash.deep_transform_keys! { |key| key.underscore } }
          event_args = { "sequence_number" => frame.sequence_number, "transactions" => transactions }
          event_args = event_args.to_ostruct.freeze
          @on_get_account_transactions.each { |proc| proc.call(event_args) }  
        when "GetAccountPositions"
          positions = frame.payload.each { |hash| hash.deep_transform_keys! { |key| key.underscore } }
          event_args = { "sequence_number" => frame.sequence_number, "positions" => positions }
          event_args = event_args.to_ostruct.freeze
          @on_get_account_positions.each { |proc| proc.call(event_args) }  
        when "GetAccountTrades"
          trades = frame.payload.each { |hash| hash.deep_transform_keys! { |key| key.underscore } }
          event_args = { "sequence_number" => frame.sequence_number, "trades" => trades }
          event_args = event_args.to_ostruct.freeze
          @on_get_account_trades.each { |proc| proc.call(event_args) }  
        when "SendOrder"
          event_args = { "sequence_number" => frame.sequence_number }.merge(frame.payload.deep_transform_keys! { |key| key.underscore })
          event_args = event_args.to_ostruct.freeze
          @on_get_send_order.each { |proc| proc.call(event_args) } 
        when "CancelOrder"
          event_args = { "sequence_number" => frame.sequence_number }.merge(frame.payload.deep_transform_keys! { |key| key.underscore })
          event_args = event_args.to_ostruct.freeze
          @on_cancel_order.each { |proc| proc.call(event_args) } 
        when "GetOrderStatus"
          order_status = frame.payload.deep_transform_keys! { |key| key.underscore }
          event_args = { "sequence_number" => frame.sequence_number, "order_status" => order_status }
          event_args = event_args.to_ostruct.freeze
          @on_get_order_status.each { |proc| proc.call(event_args) } 
        when "GetOrderFee"
          event_args = { "sequence_number" => frame.sequence_number }.merge(frame.payload.deep_transform_keys! { |key| key.underscore })
          event_args = event_args.to_ostruct.freeze
          @on_get_order_fee.each { |proc| proc.call(event_args) }
        when "GetOrderHistory"
          orders = frame.payload.each { |hash| hash.deep_transform_keys! { |key| key.underscore } }
          event_args = { "sequence_number" => frame.sequence_number, "orders" => orders }
          event_args = event_args.to_ostruct.freeze
          @on_get_order_history.each { |proc| proc.call(event_args) }
        when "GetOpenOrders"
          orders = frame.payload.each { |hash| hash.deep_transform_keys! { |key| key.underscore } }
          event_args = { "sequence_number" => frame.sequence_number, "orders" => orders }
          event_args = event_args.to_ostruct.freeze
          @on_get_order_history.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "CreateWithdrawTicket"
          event_args = { "sequence_number" => frame.sequence_number }.merge(frame.payload.deep_transform_keys! { |key| key.underscore })
          event_args = event_args.to_ostruct.freeze
          @on_create_withdraw_ticket.each { |proc| proc.call(event_args) }
        when "SubscribeLevel1"
          market_data_level1 = frame.payload.deep_transform_keys! { |key| key.underscore }
          event_args = { "sequence_number" => frame.sequence_number, "market_data_level1" => market_data_level1 }
          event_args = event_args.to_ostruct.freeze
          @on_subscribe_level_1.each { |proc| proc.call(event_args) }
        when "UnsubscribeLevel1"
          event_args = { "sequence_number" => frame.sequence_number }.merge(frame.payload.deep_transform_keys! { |key| key.underscore })
          event_args = event_args.to_ostruct.freeze
          @on_ubsubscribe_level_1.each { |proc| proc.call(event_args) }
        when "SubscribeLevel2"
          market_data_level2 = frame.payload.deep_transform_keys! { |key| key.underscore }
          event_args = { "sequence_number" => frame.sequence_number, "market_data_level2" => market_data_level2 }
          event_args = event_args.to_ostruct.freeze
          @on_subscribe_level_2.each { |proc| proc.call(event_args) }
        when "UnsbuscribeLevel2"
          event_args = { "sequence_number" => frame.sequence_number }.merge(frame.payload.deep_transform_keys! { |key| key.underscore })
          event_args = event_args.to_ostruct.freeze
          @on_unsubscribe_level_2.each { |proc| proc.call(event_args) }
        when "SubscribeTrades"
          market_trades = frame.payload.each { |hash| hash.deep_transform_keys! { |key| key.underscore } }
          event_args = { "sequence_number" => frame.sequence_number, "market_trades" => market_trades }
          event_args = event_args.to_ostruct.freeze
          @on_subscribe_trades.each { |proc| proc.call(event_args) }
        when "UnsubscribeTrades"
          event_args = { "sequence_number" => frame.sequence_number }.merge(frame.payload.deep_transform_keys! { |key| key.underscore })
          event_args = event_args.to_ostruct.freeze
          @on_unsubscribe_trades.each { |proc| proc.call(event_args) }
        when "SubscribeAccountEvents"
          event_args = { "sequence_number" => frame.sequence_number }.merge(frame.payload.deep_transform_keys! { |key| key.underscore })
          event_args = event_args.to_ostruct.freeze
          @on_subscribe_account_events.each { |proc| proc.call(event_args) }
        end
      when MessageType.event
        case frame.function_name
        when "Level1UpdateEvent"
          market_data_level1 = frame.payload.deep_transform_keys! { |key| key.underscore }
          event_args = { "sequence_number" => frame.sequence_number, "market_data_level1" => market_data_level1 }
          event_args = event_args.to_ostruct.freeze
          @level_1_update_event.each { |proc| proc.call(event_args) }
        when "Level2UpdateEvent"
          market_data_level2 = frame.payload.deep_transform_keys! { |key| key.underscore }
          event_args = { "sequence_number" => frame.sequence_number, "market_data_level2" => market_data_level2 }
          event_args = event_args.to_ostruct.freeze
          @level_2_update_event.each { |proc| proc.call(event_args) }
        when "TradeDataUpdateEvent"
          market_trades = frame.payload.each { |hash| hash.deep_transform_keys! { |key| key.underscore } }
          event_args = { "sequence_number" => frame.sequence_number, "market_trades" => market_trades }
          event_args = event_args.to_ostruct.freeze
          @trade_data_update_event.each { |proc| proc.call(event_args) }
        when "PendingDepositUpdate"
          event_args = { "sequence_number" => frame.sequence_number }.merge(frame.payload.deep_transform_keys! { |key| key.underscore })
          event_args = event_args.to_ostruct.freeze
          @pending_deposit_update.each { |proc| proc.call(event_args) }
        when "AccountPositionEvent"
          positions = frame.payload.each { |hash| hash.deep_transform_keys! { |key| key.underscore } }
          event_args = { "sequence_number" => frame.sequence_number, "positions" => positions }
          event_args = event_args.to_ostruct.freeze
          @account_position_event.each { |proc| proc.call(event_args) }
        when "OrderStateEvent"
          order_status = frame.payload.deep_transform_keys! { |key| key.underscore }
          event_args = { "sequence_number" => frame.sequence_number, "order_status" => order_status }
          event_args = event_args.to_ostruct.freeze
          @order_state_event.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "OrderTradeEvent"
          trade = frame.payload.each { |hash| hash.deep_transform_keys! { |key| key.underscore } }
          event_args = { "sequence_number" => frame.sequence_number, "trade" => trade }
          event_args = event_args.to_ostruct.freeze
          @order_trade_event.each { |proc| proc.call(event_args) }
        when "NewOrderRejectEvent"
          event_args = { "sequence_number" => frame.sequence_number }.merge(frame.payload.deep_transform_keys! { |key| key.underscore })
          event_args = event_args.to_ostruct.freeze
          @new_order_reject_event.each { |proc| proc.call(event_args) }
        when "CancelOrderRejectEvent"
          event_args = { "sequence_number" => frame.sequence_number }.merge(frame.payload.deep_transform_keys! { |key| key.underscore })
          event_args = event_args.to_ostruct.freeze
          @cancel_order_reject_event.each { |proc| proc.call(event_args) }
        when "MarketStateUpdate"
          event_args = { "sequence_number" => frame.sequence_number }.merge(frame.payload.deep_transform_keys! { |key| key.underscore })
          event_args = event_args.to_ostruct.freeze
          @market_state_update.each { |proc| proc.call(event_args) }
        end
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

# Monkey Patches

String.class_eval do
  def underscore
    self.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
  end
end
    
Hash.class_eval do
  def deep_transform_keys!(&block)
    keys.each do |key|
      value = delete(key)
      self[yield(key)] = value.is_a?(Hash) ? value.deep_transform_keys!(&block) : value
    end
    self
  end

  def to_ostruct
    JSON.parse to_json, object_class: OpenStruct
  end
end
