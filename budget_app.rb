require 'sinatra'
require "sinatra/content_for"
require "tilt/erubis"

require_relative "database_persistance"

configure(:development) do
  require "sinatra/reloader"
end

def load_income(id)
  income = @storage.find_income(id)
  return income if income

  session[:error] = "The specified income was not found."
  redirect "/lists"
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

# add a new income entry
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

# edit an existing income
get "/income/:id/edit" do
  @current_income = @storage.find_income(params[:id].to_i)
  erb :edit_income, layout: :layout
end

post "/income/:id" do
  title = params[:title].strip
  memo = !params[:memo] ? '' : params[:memo].strip
  monthly_income = params[:income]
  duration = params[:duration]
  id = params[:id].to_i

  @current_income = @storage.find_income(id)

  @storage.edit_income(title, memo, monthly_income, duration, id)
  redirect "/income"
end

# delete a income entry
post "/income/:id/destroy" do
  @storage.delete_income(params[:id].to_i)
  redirect "/income"
end
