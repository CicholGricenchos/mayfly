require 'sinatra'
require 'sinatra/activerecord'
require 'maruku'


set :database, {adapter: "sqlite3", database: "development.sqlite3"}

enable :sessions

get "/admin" do 
  session[:verified] = true if params[:pass] == "mayflyorg"
  @session = session[:verified]? "verified : true" : "verified : false"
  erb :admin
end
