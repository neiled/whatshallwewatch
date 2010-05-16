require 'rubygems'
require 'sinatra'
require 'haml'
require 'imdb'

configure :development do
  Sinatra::Application.reset!
  use Rack::Reloader
end


get '/' do
  haml :main
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

      @result = "#{@title} rated #{@rating.to_s}"
      @result += " and #{@film_count} more..." unless @film_count == 1
    end
  end
  "$(\"#film_#{@film_number}_result\").html(\"#{@result}\");"  
end
