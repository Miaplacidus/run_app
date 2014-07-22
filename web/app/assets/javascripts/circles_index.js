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

  $(document).on('click', 'a.join_circle_form', function(){
      $(this).closest('li').find('form').toggle();
    });

  $(document).on('click', '.modal-footer .submit', function(){
    $('#create_post').submit();
  });

  $(document).on('click', '.delete_post_link', function (){
    $(this).closest('li').find('form').toggle();
  });

  $(document).on('click', '.check_in_link', function(){
    var id = $(this).closest('li').parents('li').attr('id');

  });


});
