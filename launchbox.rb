require 'sinatra'
require 'sinatra/activerecord'
require 'tilt/erb'

require './models/box.rb'
require './models/link.rb'

helpers do
  def get_or_make_box
    @ip = request.ip

    if Box.exists?(ip: @ip)
      return @box = Box.find_by(ip: @ip)
    else
      @box = Box.new(ip: @ip)
      @box.save
      return @box
    end
  end
end

get '/' do
  @box = get_or_make_box
  @box.links.order(created_at: :asc)

  erb :'box/index'
end

get '/get-ip' do
  erb :'get-ip'
end

get '/what-is-this-even' do
  erb :'description', :layout => :'layout_naked'
end

get '/box/links/create' do
  @box = get_or_make_box

  erb :'links/create'
end

post '/box/links/create' do
  @box = get_or_make_box

  @link = @box.links.new(params[:link])

  if @link.save
    redirect to("/")
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
