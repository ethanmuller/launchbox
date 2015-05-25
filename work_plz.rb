require 'sinatra'
require 'sinatra/activerecord'
require 'tilt/erb'

require './models/box.rb'
require './models/link.rb'

set :local_mode, true

get '/' do
  "Hello!"
end
