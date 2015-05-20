require 'bundler'
Bundler.require(:default)
require 'sass/plugin/rack'
require './launchbox.rb'

Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

run Sinatra::Application
