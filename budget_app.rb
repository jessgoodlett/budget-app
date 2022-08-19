require 'sinatra'
require "sinatra/content_for"
require "tilt/erubis"

require_relative "database_persistance"

configure(:development) do
  require "sinatra/reloader"
end

before do
  @storage = DatabasePersistance.new
  @user = 1
end

get "/" do
  erb :user_dashboard, layout: :layout
end

get "/income" do
  @income = @storage.list_user_income(@user)
  @total_income = @storage.calculate_income(@user)
  erb :income, layout: :layout
end

get "/income/new" do
  erb :new_income, layout: :layout
end

post "/income" do
  title = params[:title].strip
  memo = !params[:memo] ? '' : params[:memo].strip
  monthly_income = params[:income]
  duration = params[:duration]

  @storage.add_new_income(title, memo, monthly_income, duration, @user)
  redirect "/income"
end