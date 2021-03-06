$(document).ready(function() {
  $(".film_form").ajaxForm({
    dataType: 'script',
    success: function(responseText, statusText){
      $('.film_form').resetForm();
    }
  });  
  $("#film_name").autocomplete({
    source: function(request, response) {
      $.ajax({
        url: "/api/v1/film_search/",
        data: { term: request.term},
        success: function(data) {
          response($.map(data, function(film_item) {
            return {label: film_item.title, value: film_item}
          }))
        }
      });
    },
    minLength: 2,
    focus: function( event, ui ) {
      $( "#film_name" ).val( ui.item.label );
      return false;
    },
    select: function( event, ui ) {
      window.films.add([ui.item.value]);
      $("#film_name").val('');
      return false;
    }
     });

     $("#film_name").focus();

});

(function($) {
  
  window.Film = Backbone.Model.extend({
    getFilmQuality: function() {
        var rating = this.get('rating');
        if(rating > 90) return 'amazing';
        if(rating > 75) return 'very good';
        if(rating > 60) return 'good';
        return 'not good';
    },
    toString : function() {
    return "test";
    }
  });

  window.FilmView = Backbone.View.extend({
    initialize: function() {
      this.template = _.template($('#film-template').html());
    },

    render: function() {
      var renderedContent = this.template(this.model.toJSON());
      $(this.el).html(renderedContent);
      return this;
    }
  
  });
  
  window.Films = Backbone.Collection.extend({
    model: Film,
    comparator: function(film) { return -film.get('rating');}

  
  });


  window.films = new Films();
  
  window.FilmsView = Backbone.View.extend({
    initialize: function() {
        _.bindAll(this, 'render');
        this.template = _.template($('#films-template').html());
        this.collection.bind('add', this.render);
      },

      render: function() {
        var $films,
            collection = this.collection;

        var renderedContent = this.template({});
        $(this.el).html(renderedContent);


        $films = this.$('#films');
        collection.each(function(film) {
          var view = new FilmView({
            model: film,
            collection: collection
          });


          $films.append(view.render().el)
        });

        return this;
      }
    

  });


  window.BackboneFilms = Backbone.Router.extend({
    routes: {
              '': 'home'
            },

    initialize: function() {
      this.filmsView = new FilmsView({collection: window.films});
    },

    home: function() {
            var $container = $('#film_results_box');
            $container.empty();
            $container.append(this.filmsView.render().el);
  }
  });

  $(function() {
    window.App = new BackboneFilms();
    Backbone.history.start();
  });

})(jQuery);
