require 'thin'
require 'sinatra/base'
require 'em-websocket'
# require_relative 'redmond'

EventMachine.run do
  class App < Sinatra::Base
    get '/' do
      slim :index
    end
  end

  # our WebSockets server logic will go here

  App.run! port: 3001
end