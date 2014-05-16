require 'sinatra'
require 'sinatra/activerecord'
require 'maruku'
require './models/article'
require './models/user'
require './models/category'

set :database, {adapter: "sqlite3", database: "development.sqlite3"}

enable :sessions

get "/admin" do 
  session[:verified] = true if params[:pass] == "mayflyorg"
  @session = session[:verified]? "verified : true" : "verified : false"
  erb :admin
end

post "/new_article" do 
  if session[:verified]
    Article.create(:title => params[:title], :content => params[:content], :brief => params[:brief])
  end
end

get "/article/:id" do 
  article = Article.find(params[:id])
  @content = Maruku.new(article.content)
  @content = @content.to_html
  @title = article.title
  @date = article.created_at
  @author = User.find(article.author).name
  @category = Category.find(article.category).name

end
