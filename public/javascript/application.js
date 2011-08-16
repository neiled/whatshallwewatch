var current_film_count = 2;

$(document).ready(function() {
  $(".film_form").ajaxForm({
    dataType: 'script',
    success: function(responseText, statusText){
      $('.film_form').resetForm();
    }
  });  
});

(function($) {
  
  window.Film = Backbone.Model.extend({
  
  });
})(jQuery);
