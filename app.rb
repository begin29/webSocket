require 'sinatra'
require 'sinatra-websocket'
require 'slim'

set :server, 'thin'
set :sockets, []

get '/:id' do
  if !request.websocket?
    slim :one_chanel, locals: {chat_name: params[:id]}
  else
    request.websocket do |ws|
      channel = params[:id]
      @con = {channel: channel, socket: ws, color: params[:color] || 'FFFFFF'}
      ws.onopen do
        ws.send("Hello From WebSocket Server! <br\>")
        settings.sockets << @con
      end
      ws.onmessage do |msg|
        return_array = []
        settings.sockets.each do |hash|
          if hash[:channel] == channel
            return_array << hash
            p "Same channel"
          else
            p hash[:channel]
            p "Not in same channel"
          end
        end
        EM.next_tick { return_array.each{|s| s[:socket].send("<p style='color:##{params[:color]}'>#{msg}</p>") } }
      end
      ws.onclose do
        warn("websocket closed")
        settings.sockets.each do |hash|
          if hash[:socket] == ws
            settings.sockets.delete(hash)
          else
            p "not deleted"
          end
        end
      end
    end
  end
end