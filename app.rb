require 'sinatra'
require 'sinatra/activerecord'
require 'maruku'
require './models/article'

set :database, {adapter: "sqlite3", database: "development.sqlite3"}

#get "/new" do
#  erb :new_article
#end

#post "/new" do
#  Article.create(:title => params[:title], :brief => params[:brief], :content => params[:content])
#  puts 'OK'
#end

get "/article/:id" do 
  article = Article.find(params[:id])
  @content = Maruku.new(article.content)
  @content = @content.to_html
  @title = article.title
  @page_title = "蜉蝣人文爱好小组 - #{@title}" 
  erb :page
end

get '/' do
  
end
