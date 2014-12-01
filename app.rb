require 'sinatra'
require 'sinatra-websocket'
require 'slim'

set :server, 'thin'
set :sockets, []

# get '/' do
#   if !request.websocket?
#     slim :index
#   else
#     request.websocket do |ws|
#       ws.onopen do
#         ws.send("Hello World!")
#         settings.sockets << ws
#       end
#       ws.onmessage do |msg|
#         EM.next_tick { settings.sockets.each{|s| s.send(msg) } }
#       end
#       ws.onclose do
#         warn("websocket closed")
#         settings.sockets.delete(ws)
#       end
#     end
#   end
# end

get '/:id' do
  if !request.websocket?
    slim :one_chanel
  else
    request.websocket do |ws|
      channel = params[:id]
      @con = {channel: channel, socket: ws, color: params[:color] || 'black'}
      ws.onopen do
        ws.send("Hello From WebSocket Server!")
        settings.sockets << @con
      end
      ws.onmessage do |msg|
        return_array = []
        settings.sockets.each do |hash|
          #puts hash
          #puts hash['channel']
          if hash[:channel] == channel
            #puts hash[:socket]
            return_array << hash
            puts "Same channel"
            # puts return_array
          else
            puts hash[:channel]
            puts channel
            puts "Not in same channel"
          end
        end
        EM.next_tick { return_array.each{|s| s[:socket].send("<p style='color:##{s[:color]}'>#{msg}</p>") } }
      end
      ws.onclose do
        warn("websocket closed")
        settings.sockets.each do |hash|
          if hash[:socket] == ws
            settings.sockets.delete(hash)
            puts "deleted"
          else
            puts "not deleted"
          end
        end
      end
    end
  end
end