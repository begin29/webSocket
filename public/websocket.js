$( document ).ready(function() {
 var show = function(el){
    return function(msg){ el.innerHTML = msg + el.innerHTML; }
  }(document.getElementById('msgs'));
  
  var ws ;
  var client = $.now().toString();
  var color;
  var connect = function(b){
    var random_val = Math.floor((Math.random() * 1000) + 3);
    color = random_val + client.substr(client.length - 3);
    b.onclick = function(){
      ws       = new WebSocket('ws://' + window.location.host + window.location.pathname+ '?color='+color);
      ws.onopen    = function()  { show('websocket opened'); };
      ws.onclose   = function()  { show('websocket closed'); }
      ws.onmessage = function(m) { show(m.data); };
      $(this).hide();
      $('#disconnect').show();
      return false;
    };
  }(document.getElementById('connect') )

  $('#disconnect').on('click', function(){
    $(this).hide();
    $('#connect').show();
    ws.close();
    return false;
  });

  var sender = function(f){
    var input     = document.getElementById('input');
    input.onclick = function(){ input.value = "" };
    f.onsubmit    = function(){
      if(typeof ws !== 'undefined')
      {
        send_object = ws.send(client+': ' + input.value);
        input.value = "send a message";
      }
      else{
        alert('please connect to WebSocket server');
      };
      return false;
    }
  }(document.getElementById('form'));

});