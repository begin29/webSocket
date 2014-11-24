module Redmond
  def post_init
    puts "We're sending a dumb HTTP request to the remote peer."
    send_data "GET / HTTP/1.1\r\nHost: www.microsoft.com\r\n\r\n"
  end

  def receive_data data
    puts "We received #{data.length} bytes from the remote peer."
    puts "We're going to stop the event loop now."
    EventMachine::stop_event_loop
  end

  def unbind
    puts "A connection has terminated."
  end
end