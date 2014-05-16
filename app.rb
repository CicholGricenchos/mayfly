require 'sinatra'
require 'maruku'

enable :sessions

get "/admin" do 
  session[:verified] = true if params[:pass] == "mayflyorg"
  @session = session[:verified]? "verified : true" : "verified : false"
  a = Maruku.new("abc")
  a.to_html
  erb :admin
end

