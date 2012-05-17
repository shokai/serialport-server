
$(function(){
    $('.led .on').click(function(){
        $.post($('#addr').val(), 'o', function(){
            alert('led on');
        });
    });
    $('.led .off').click(function(){
        $.post($('#addr').val(), 'x', function(){
            alert('led off');
        });
    });
    setInterval(function(){
        $.getJSON($('#addr').val(), {}, function(data){
            $('.cds input').val( data[0].data );
        });
    }, 100);
});
