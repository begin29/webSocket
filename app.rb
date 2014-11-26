require 'thin'
require 'sinatra/base'
require 'em-websocket'
require 'slim'

EventMachine.run do
  class App < Sinatra::Base
    configure do
      set :server, %w[thin]
    end

    get '/' do
      slim :index
    end

  end

  # @clients = []

  EM::WebSocket.start(:host => '0.0.0.0', :port => '3001') do |ws|
    ws.onopen do |handshake|
      # @clients = ws
      ws.send "Connected to #{handshake.path}."
    end

    ws.onclose do |closed| 
      p "Connection closed"
    end

    ws.onmessage do |msg|
      puts "Recieved message: #{msg}"
      ws.send "Pong: #{msg}"
    end
  end

  # App.run! port: 3000
end