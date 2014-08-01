$(document).ready(function(){


  $('#circle_radius_select').change(function(){
    $('#capacity').val('0');
  });

  $('#circle_radius_select, #capacity').change(function() {

  $.ajax({ type: "GET",
           url: "/circles/display.js",
           data: $("#circle_filter_form").serialize(),
           success : function(text) {
              // alert('success');
              // console.log(text);
           }
  });
});

  $(document).on('click', 'a.send_join_req', function(){
    var id = $(this).closest('li').parents('li').attr('id');

    $.ajax({ type: "POST",
         url: "/circles/join.js",
         data: {
            circle_id: id
         },
         success : function(text) {
            // alert('success');
            // console.log(text);
         }
    });
    });

  $(document).on('click', '.modal-footer .circle_submit', function(){
    $('#create_circle').submit();
  });

  $(document).on('click', '.modal-footer .cp_submit', function(){
    $('#create_cp').submit();
  });

  $(document).on('click', '.send_challenge', function(){
    $(this).closest('li').find('form').toggle();
  });


  $(document).on('click', '.delete_post_link', function (){
    $(this).closest('li').find('form').toggle();
  });

  $(document).on('click', '.check_in_link', function(){
    var id = $(this).closest('li').parents('li').attr('id');

  });


});
