require 'sinatra'
require "sinatra/content_for"
require "tilt/erubis"

configure(:development) do
  require "sinatra/reloader"
end

get "/" do
  erb :user_dashboard, layout: :layout
end
