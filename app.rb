#encoding : utf-8

require 'sinatra'
require 'sinatra/activerecord'
require 'maruku'
require './models/article'
require './models/user'
require './models/category'
require './models/article_comment'
require 'fileutils'

set :database, {adapter: "sqlite3", database: "development.sqlite3"}

enable :sessions

get "/admin" do 
  session[:verified] = true if params[:pass] == "mayflyorg"
  @session = session[:verified]? "verified : true" : "verified : false"
  erb :admin
end

post "/new_article" do 
  if session[:verified]
    Article.create(:title => params[:title], :content => params[:content], :brief => params[:brief], :author => 1, :category => 4)
  end
end

get "/article/9" do 
  article = Article.find(9)
  @content = Maruku.new(article.content)
  @content = @content.to_html
  @title = article.title
  @date = article.created_at
  @brief = article.brief
  @author = User.find(article.author).name
  @category = Category.find(article.category).name
  @category_id = Category.find(article.category).id
  @page_title = "蜉蝣人文爱好小组 - #{@title}"
  @content = erb :article
  @category_list = ""
  categories = Category.where("id != 4").all
  categories.each do |x|
    @category_id = x.id
    @category_name = x.name
    @category_list += erb :category_list
  end
  @comment = ""
  comments = ArticleComment.where(:article_id => 9).all
  comments.each do |x|
    @comment_author = x.author 
    @comment_time = x.created_at 
    @comment_content = x.content 
    @comment += erb :comment 
  end
  @article_id = 9
  @comment_area = erb :comment_area
  erb :about_page
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
  @category_id = Category.find(article.category).id
  @page_title = "蜉蝣人文爱好小组 - #{@title}"
  @content = erb :article
  @category_list = ""
  categories = Category.where("id != 4").all
  categories.each do |x|
    @category_id = x.id
    @category_name = x.name
    @category_list += erb :category_list
  end
  @comment = ""
  comments = ArticleComment.where(:article_id => params[:id].to_i).all
  comments.each do |x|
    @comment_author = x.author 
    @comment_time = x.created_at 
    @comment_content = x.content 
    @comment += erb :comment 
  end
  @article_id = params[:id]
  @comment_area = erb :comment_area
  erb :article_page
end

get '/' do
  @page_title = "蜉蝣人文爱好小组"
  articles = Article.order("id DESC").where("category != 4").limit(10).all
  @content = ""
  articles.each do |x|
    @id = x.id
    @brief = x.brief
    @title = x.title
    @date = x.created_at
    @author = User.find(x.author).name
    @category = Category.find(x.category).name
    @category_id = Category.find(x.category).id
    @content += erb :menu
  end
  @category_list = ""
  categories = Category.where("id != 4").all
  categories.each do |x|
    next if x.id==4
    @category_id = x.id
    @category_name = x.name
    @category_list += erb :category_list
  end
  erb :index_page
end

get "/category/1" do 
  @name = Category.find(1).name
  @page_title = "蜉蝣人文爱好小组 - #{@name}"
  articles = Article.where(:category => 1).order("id DESC").limit(10)
  @content = ""
  articles.each do |x|
    @id = x.id
    @brief = x.brief
    @title = x.title
    @date = x.created_at
    @author = User.find(x.author).name
    @category = Category.find(x.category).name
    @category_id = Category.find(x.category).id
    @content += erb :menu
  end
  @category_list = ""
  categories = Category.where("id != 4").all
  categories.each do |x|
    @category_id = x.id
    @category_name = x.name
    @category_list += erb :category_list
  end
  erb :design_page
end

get "/category/:id" do 
  @name = Category.find(params[:id].to_i).name
  @page_title = "蜉蝣人文爱好小组 - #{@name}"
  articles = Article.where(:category => params[:id].to_i).order("id DESC").limit(10)
  @content = ""
  articles.each do |x|
    @id = x.id
    @brief = x.brief
    @title = x.title
    @date = x.created_at
    @author = User.find(x.author).name
    @category = Category.find(x.category).name
    @category_id = Category.find(x.category).id
    @content += erb :menu
  end
  @category_list = ""
  categories = Category.where("id != 4").all
  categories.each do |x|
    @category_id = x.id
    @category_name = x.name
    @category_list += erb :category_list
  end
  erb :site_page
end

get "/database" do 
  if session[:verified]
    FileUtils.cp("development.sqlite3","./public")
    "Verified OK, Database in the place."
  end
end

get "/user/:id" do 
  user = User.find(params[:id])
  @introduction = Maruku.new(user.introduction)
  @introduction = @introduction.to_html
  @name = user.name
  @page_title = "蜉蝣人文爱好小组 - #{@name}"
  @content = erb :user
  @category_list = ""
  categories = Category.where("id != 4").all
  categories.each do |x|
    @category_id = x.id
    @category_name = x.name
    @category_list += erb :category_list
  end
  erb :site_page
end

post "/article_comment/:id" do 
  ArticleComment.create(:article_id => params[:id].to_i, :content => params[:content].gsub(/<\/?.*?>/,""), :author => params[:name].gsub(/<\/?.*?>/,""))
  redirect to("/article/#{params[:id]}")
end
