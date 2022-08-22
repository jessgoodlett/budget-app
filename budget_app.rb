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

# debt pages
get "/debt" do
  @debt = @storage.list_user_debt(@user)
  @total_debt = @storage.calculate_debt(@user)
  erb :debt
end

get "/debt/new" do
  erb :new_debt
end

post "/debt" do
  title = params[:title].strip
  amount = params[:amount]
  category = params[:category]

  @storage.add_new_debt(title, amount, category, @user)
  redirect "/debt"
end

get "/debt/:id/edit" do
  @current_debt = @storage.find_debt(params[:id].to_i)
  erb :edit_debt
end

post "/debt/:id" do
  title = params[:title].strip
  amount = params[:amount]
  category = params[:category]
  id = params[:id].to_i

  @storage.edit_debt(title, amount, category, id)
  redirect "/debt"
end

post "/debt/:id/destroy" do
  @storage.delete_debt(params[:id].to_i)
  redirect "/debt"
end

# savings pages
get "/savings" do
  @accounts = @storage.list_user_savings(@user)
  @total_saved = @storage.calculate_savings(@user)
  erb :savings
end

get "/savings/new" do
  erb :new_savings
end

post "/savings" do
  title = params[:title].strip
  amount = params[:amount]
  category = params[:category]

  @storage.add_new_savings(title, amount, category, @user)
  redirect "/savings"
end

get "/savings/:id/edit" do
  @current_savings = @storage.find_savings(params[:id].to_i)
  erb :edit_savings
end

post "/savings/:id" do
  title = params[:title].strip
  amount = params[:amount]
  category = params[:category]
  id = params[:id].to_i

  @storage.edit_savings(title, amount, category, id)
  redirect "/savings"
end

post "/savings/:id/destroy" do
  @storage.delete_savings(params[:id].to_i)
  redirect "/savings"
end