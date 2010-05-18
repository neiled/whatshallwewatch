require 'rubygems'
require 'sinatra'
require 'haml'
require 'imdb'

configure :development do
    Sinatra::Application.reset!
    enable :logging, :dump_errors, :raise_errors
    use Rack::Reloader
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end


get '/' do
  haml :main
end

get '/base.css' do
  headers 'Content-Type' => 'text/css; charset=utf-8'
  sass :base
end


post '/lookup' do
  @film_name = params[:film_name]
  @film_number = params[:film_number]  

  @result = "No film found :("  
  unless @film_name.empty?
  
    @films_found = Imdb::Search.new(@film_name.to_s)
    @film_count = @films_found.movies.count
  
    unless @film_count == 0
        @title = @films_found.movies.first.title
        @rating = @films_found.movies.first.rating

        #@result = "#{@title} rated #{@rating.to_s}"
        #@result += " and #{@film_count} more..." unless @film_count == 1
        @result = get_film_result(@films_found.movies.first, @film_count, @film_number)
    end
  end
  "$(\"#film_#{@film_number}_results\").after(\"#{@result}\").remove();$(\"#film_#{@film_number}_search\").html(\"\");" 
end

def get_film_result(film, film_count, film_number)
    result = "<div id=\'film_#{film_number}_results\'>"
    title_and_rating = "<div class=\'title\'>#{film.title}</div> <div class=\'rating\'>#{film.rating.to_s}</div>"
    remaining = "<div class=\'remaining\'>#{(film_count unless film_count == 1)}</div>"
    result + title_and_rating + remaining + "</div>"
end 
