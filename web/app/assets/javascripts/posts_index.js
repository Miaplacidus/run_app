$(document).ready(function(){

  $('#pace_select, #age_select, #time_select').toggle();

  $('#radius_select, #gender_select').change(function(){
    $('#pace_select, #age_select, #time_select').hide();
    $('#filter_select').val('0');
  });

  $('#filter_select').change(function() {
    var filter = "#" + $("#filter_select option:selected").text() + "_select";
    filter = filter.toLowerCase();
    $('#pace_select, #age_select, #time_select').hide();
    $(filter).toggle();
  });

  $('#radius_select, #gender_select, #pace_select, #age_select').change(function(){

    $.ajax({ type: "GET",
             url: "/posts/display.js",
             data: $("#filter_form").serialize(),
             success : function(text) {
                // alert('success');
                // console.log(text);
             }
    });
  });

  $(document).on('click', 'a.join_form', function(){
    $(this).closest('li').find('form').toggle();
  });

  $(document).on('click', '#postcreatemodal .modal-footer .submit', function(){
    $('#createpostform').submit();
  });

  $(document).on('click', 'div.admin_all #delete_post_link', function(){
    var delete_form = $(this).closest('li').find('form');

    if (delete_form.css('display') != 'none'){
      delete_form.show();
    }
    else {
      delete_form.hide();
    }
  });

  $(document).on('click', 'div.admin_all .delete_cancel', function(){
    $(this).closest('li').find('form').hide();
  });


  $(document).on('click', '.check_in_link', function(){
    var id = $(this).closest('li').parents('li').attr('id');

    navigator.geolocation.getCurrentPosition(GetLocation);
    function GetLocation(location) {
      var user_lat = location.coords.latitude;
      var user_lon = location.coords.longitude;

      console.log(user_lat);
      console.log(user_lon);

      $.ajax({ type: "PUT",
           url: "/posts/checkin.js",
           data: {
                user_lat: user_lat,
                user_lon: user_lon,
                id: id
           },
           success : function(text) {
              // alert('success');
           }
      });
    }
  });


});
