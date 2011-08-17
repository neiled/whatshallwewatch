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
  film_name = params[:film_name]
  title = "No film found :("
  rating = 0

  unless film_name.empty?
    bf = BadFruit.new("vq8jhsqmw6qkarkcsa5grxbd")

    films_found = bf.movies.search_by_name(film_name.to_s)
    film_count = films_found.count

    unless film_count == 0
        title = films_found.first.name
        rating = films_found.first.scores.average
    end
  end
  "window.films.add([{title: \"#{title}\", rating: #{rating}, quality: \"#{get_quality(rating)}\"}]);"
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


def get_quality(rating)
  if(rating > 85)
    'amazing'
  elsif(rating > 75)
    'very-good'
  elsif(rating > 60)
    'good'
  else
    'not-good'
  end
end
