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

  $('#radius_select, #gender_select, #pace_select, #age_select').change(function() {

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

});
