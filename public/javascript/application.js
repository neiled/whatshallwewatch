var current_film_count = 2;

$(document).ready(function() {
  $(".film_form").ajaxForm({
    dataType: 'script'
  });
  
  $(".film_name").live('focusout', function(event) {
    var film_number = $(this).parent().children("input:hidden").val();
    $("#film_"+film_number+"_search").html("Searching...");
    $(this).parent().submit();
  });
  
  $(".add_film").live('focusin', function(event) {
    //remove all the add_film classes
    $(".add_film").removeClass('add_film');
    
    //add the new film form
    current_film_count++;
    $("#film_form").append(
      "<form action='/lookup' class='film_form add_film' method='POST'>"+
        "<label>Film </label>"+
        "<input class='film_name' name='film_name' type='text' value='' />"+
        "<input name='film_number' type='hidden' value='"+current_film_count+"' />"+
      "</form>"+
      "<div id='film_"+current_film_count+"_search'>Tab to the next box to search</div>"
    );
    $("#film_results_box").append("<div id='film_"+current_film_count+"_results'></div>");
    //make sure they're all set to ajax form still
    $(".film_form").ajaxForm({
      dataType: 'script'
    });
  });
  
});
