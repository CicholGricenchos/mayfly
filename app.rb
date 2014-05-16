#encoding : utf-8

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
    Article.create(:title => params[:title], :content => params[:content], :brief => params[:brief], :author => 1, :category => 3)
  end
end

get "/article/:id" do 
  article = Article.find(params[:id])
  @content = Maruku.new(article.content)
  @content = @content.to_html
  @title = article.title
  @date = article.created_at
  @brief = article.brief
  @author = User.find(article.author).name
  @category = Category.find(article.category).name
  @page_title = "蜉蝣人文爱好小组 - #{@title}"
  @content = erb :article
  erb :page
end

get '/' do
  @page_title = "蜉蝣人文爱好小组"
  articles = Article.order("id DESC").limit(10).all
  @content = ""
  articles.each do |x|
    @id = x.id
    @brief = x.brief
    @title = x.title
    @date = x.created_at
    @author = User.find(x.author).name
    @category = Category.find(x.category).name
    @content += erb :index
  end
  erb :page
end
