require 'faye/websocket'
require 'eventmachine'

EM.run {
  ws = Faye::WebSocket::Client.new('wss://api-cx.coins.asia/ws-api/')

  ws.on :open do |event|
    p [:open]
    ws.send ('{
    "m":0,
    "i":0,
    "n":"GetInstruments",
    "o":"{\"OMSId\": 1}"
    }')
  end

  ws.on :message do |event|
    p [:message, event.data]
    ws.close
    return event.data
  end

  ws.on :close do |event|
    p [:close, event.code, event.reason]
    ws = nil
  end
}
