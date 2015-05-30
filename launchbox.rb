require 'sinatra'
require 'sinatra/activerecord'
require 'tilt/erb'
require 'uri'

require './models/box.rb'
require './models/link.rb'

# if public mode is true,
# separate boxes will be created for each IP address that hits the app.
# Otherwise, there is no separation between links.
set :public_mode, ENV['PUBLIC_MODE'] || false

helpers do
  def get_or_make_box
    if settings.public_mode
      @ip = request.ip
    else
      @ip = "local"
    end

    if Box.exists?(ip: @ip)
      return @box = Box.find_by(ip: @ip)
    else
      @box = Box.create(ip: @ip)
      return @box
    end
  end

  def quip
    # print out a cute little quip
    # for when there aren't any links
    @quips = [
      "This is awkward.",
      "I feel so naked.",
      "Feed me.",
      "I thirst.",
      "I'm so lonely.",
      "I've got the rumblies. That only links can satisfy.",
      "Fill me up, buttercup.",
      "Hook me up."
    ]

    @quips[rand(@quips.length)]
  end

  def absolute_url(url)
    # Take a URL, and if it doesn't look absolute, prepend "http://"
    # Yeah, yeah, this belongs in a link controller. Shut up.

    if url !~ /^[(http:\/\/)(https:\/\/)(\/)(javascript:)]/
      result = "http://" + url
    else
      result = url
    end

    result
  end
end

get '/' do
  box = get_or_make_box
  @links = box.links.order(created_at: :desc)

  erb :'box/index'
end

get '/what-is-this-even' do
  erb :'description', :layout => :'layout_naked'
end

get '/box/links/create' do
  @box = get_or_make_box
  @link = @box.links.new

  @link.name = params[:name]
  @link.url = params[:url]

  erb :'links/create'
end

post '/box/links/create' do
  @box = get_or_make_box

  @link = @box.links.new(params[:link])

  if @link.save
    redirect to("/")
  else
    erb :'links/create'
  end
end


get '/box/links/:id' do
  @box = get_or_make_box
  @link = @box.links.find(params[:id])

  erb :'links/show'
end

delete '/box/links/:id' do
  @box = get_or_make_box
  begin
    @link = @box.links.find(params[:id])
    @link.destroy
  ensure
    redirect to("/")
  end
end

put '/box/links/:id' do
  @box = get_or_make_box
  @link = @box.links.find(params[:id])

  if @link.update(params[:link])
    redirect to("/")
  end
end
