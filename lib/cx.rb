require "faye/websocket"
require "json"

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

  def get_products(sequence_number)
    frame = Frame.new(0, sequence_number, "GetProducts", { "OMSId" => 1 })
    @ws.send(Frame.serialize(frame))
  end

  def get_instruments(sequence_number)
    frame = Frame.new(0, sequence_number, "GetInstruments", { "OMSId" => 1 })
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
