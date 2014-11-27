$( document ).ready(function() {
 var show = function(el){
    return function(msg){ el.innerHTML = msg + '<br />' + el.innerHTML; }
  }(document.getElementById('msgs'));

  var emulate = function(b){
    var input = $('#input');
    b.onclick = function(){
      try{var value = parseInt(input.val());} catch(e){ show(e); }
      try{
        var i = 0;
        while(i < value){ connect(i); i++;}
      } catch(e){show(e);};
      return false;
    };
  }(document.getElementById('emulate'));

  var connect = function(n){
    var ws_array = [];
    ws_array[n] = new WebSocket('ws://' + window.location.host + window.location.pathname);
    ws_array[n].onopen    = function()  { console.log('websocket opened'); };
    ws_array[n].onclose   = function()  { console.log('websocket closed'); }
    ws_array[n].onmessage = function(m) { console.log('websocket message: ' +  m.data); };
  };


  var sender = function(f){
    var input     = document.getElementById('input');
    input.onclick = function(){ input.value = "" };
    f.onsubmit    = function(){
      ws.send(input.value);
      input.value = "send a message";
      return false;
    }
  }(document.getElementById('form'));
});