$(document).ready(function(){
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

});
