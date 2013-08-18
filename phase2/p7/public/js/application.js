$(document).ready(function(){

  $('a#get_color').on('click', function(e) {

    e.preventDefault();

    var request = $.ajax({
      url: '/color',
      type: 'post',
      dataType: 'json'
    });

    request.done(function(data){
      var cellSelector = 'ul#color_me li:nth-child(' + data.cell + ')';
      $(cellSelector).css('background', data.color);
    });

  });

});
