require 'sinatra'
require 'sinatra/activerecord'
require 'tilt/erb'

require './models/box.rb'
require './models/link.rb'

set :local_mode, true

helpers do
  def get_or_make_box
    # If local mode is true, we don't need to worry about IPs.
    # Everything goes into one big, comfy box.

    if settings.local_mode
      @ip = "local"
    else
      @ip = request.ip
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
  @link = @box.links.find(params[:id])
  if @link.destroy
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
