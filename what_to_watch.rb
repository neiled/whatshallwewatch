require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
require 'badfruit'

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
    bf = BadFruit.new("vq8jhsqmw6qkarkcsa5grxbd")

    @films_found = bf.movies.search_by_name(@film_name.to_s)
    @film_count = @films_found.count

    unless @film_count == 0
        @title = @films_found.first.name
        @rating = @films_found.first.scores.average

        @result = get_film_result(@films_found, @film_number)
    end
  end
  "$(\"#film_results_box\").append(\"#{@result}\")" 
end

def get_film_result(movies, film_number)
  result = "<div id=\'film_#{film_number}_results\'>"
  title_and_rating = "<div class=\'title\'>#{movies.first.name}</div> <div class=\'rating\'>#{movies.first.scores.average.to_s}</div>"
  remaining = "<div class=\'remaining\'>#{(movies.count unless movies.count == 1)}</div>"
  others = "<div class=\'others\'>#{get_others(movies)}</div>"
  result + title_and_rating + remaining + others + "</div>"
end 

def get_others(movies)
  others = ""
  unless movies.count == 1 then
    movies.each do |e|  
      others += "<div class=\'other_movie\'><div class=\'title\'>#{e.name}</div><div class=\'id\'>#{e.id}</div></div>"
    end
  end
  
  others
end
