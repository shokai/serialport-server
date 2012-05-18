
var ws;

$(function(){
    $('.websocket .btn').click(function(){
        if(ws == null || ws.readyState != 1){
            ws = new WebSocket($('#addr').val());
            $('#addr').attr('disabled','disabled');
            $('.websocket .btn').val('close');
            ws.onopen = function(){
                alert('websocket open');
            };
            ws.onclose = function(){
                alert('websocket closed');
                $('.websocket .btn').val('open');
                $('#addr').attr('disabled',null);
            };
            ws.onmessage = function(e){
                $('.cds input').val(e.data);
            };
        }
        else{
            ws.close();
            $('.websocket .btn').val('open');
            $('#addr').attr('disabled',null);
        }
    });

    $('.led .on').click(function(){
        ws.send('o');
    });
    $('.led .off').click(function(){
        ws.send('x');
    });
});
