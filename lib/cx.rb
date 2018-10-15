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
      def transform_keys
        result = {}
        each_key do |key|
            result[yield(key)] = self[key]
        end
        result
      end
    end
    
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
          @on_get_instruments.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "WebAuthenticateUser"
          @on_web_authenticate_user.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "GetUserAccounts"
          @on_get_user_accounts.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "GetAccountTransactions"
          @on_get_account_transactions.each { |proc| proc.call(frame.sequence_number, frame.payload) }  
        when "GetAccountPositions"
          @on_get_account_positions.each { |proc| proc.call(frame.sequence_number, frame.payload) }  
        when "GetAccountTrades"
          @on_get_account_trades.each { |proc| proc.call(frame.sequence_number, frame.payload) }  
        when "SendOrder"
          @on_get_send_order.each { |proc| proc.call(frame.sequence_number, frame.payload) } 
        when "CancelOrder"
          @on_cancel_order.each { |proc| proc.call(frame.sequence_number, frame.payload) } 
        when "GetOrderStatus"
          @on_get_order_status.each { |proc| proc.call(frame.sequence_number, frame.payload) } 
        when "GetOrderFee"
          @on_get_order_fee.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "GetOrderHistory"
          @on_get_order_history.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "GetOpenOrders"
          @on_get_order_history.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "CreateWithdrawTicket"
          @on_create_withdraw_ticket.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "SubscribeLevel1"
          @on_subscribe_level_1.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "UnsubscribeLevel1"
          @on_ubsubscribe_level_1.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "SubscribeLevel2"
          @on_subscribe_level_2.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "UnsbuscribeLevel2"
          @on_unsubscribe_level_2.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "SubscribeTrades"
          @on_subscribe_trades.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "UnsubscribeTrades"
          @on_unsubscribe_trades.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "SubscribeAccountEvents"
          @on_subscribe_account_events.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        end
      when MessageType.event
        case frame.function_name
        when "Level1UpdateEvent"
          @level_1_update_event.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "Level2UpdateEvent"
          @level_2_update_event.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "TradeDataUpdateEvent"
          @trade_data_update_event.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "PendingDepositUpdate"
          @pending_deposit_update.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "AccountPositionEvent"
          @account_position_event.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "OrderStateEvent"
          @order_state_event.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "OrderTradeEvent"
          @order_trade_event.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "NewOrderRejectEvent"
          @new_order_reject_event.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "CancelOrderRejectEvent"
          @cancel_order_reject_event.each { |proc| proc.call(frame.sequence_number, frame.payload) }
        when "MarketStateUpdate"
          @market_state_update.each { |proc| proc.call(frame.sequence_number, frame.payload) }
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
