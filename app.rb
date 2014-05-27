#encoding : utf-8

require 'sinatra'
require 'sinatra/activerecord'
require 'maruku'
require './models/article'
require './models/user'
require './models/category'
require './models/article_comment'
require 'fileutils'
require './controllers/admin'

$SITE_URL = "http://localhost:4567"

set :database, {adapter: "sqlite3", database: "development.sqlite3"}

enable :sessions

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
    @content += erb :article_list
  end
  @category_list = ""
  categories = Category.where("id != 4").all
  categories.each do |x|
    next if x.id==4
    @category_id = x.id
    @category_name = x.name
    @category_list += erb :category_list
  end
  @current_nav = 1
  @nav = erb :nav
  @meta_description = "致力于改善高校校园人文环境，社会人文的观察者，热诚的实践者。"
  @meta_keywords = "蜉蝣,人文,哲学,社会,教育"
  erb :site_page
end

get "/article/:id" do 
  article = Article.find(params[:id])
  @content = Maruku.new(article.content).to_html
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
  @current_nav = 2 if params[:id]=='9'
  @nav = erb :nav
  @article_id = params[:id]
  @comment_form = erb :comment_form
  erb :site_page
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
    @content += erb :article_list
  end
  @category_list = ""
  categories = Category.where("id != 4").all
  categories.each do |x|
    @category_id = x.id
    @category_name = x.name
    @category_list += erb :category_list
  end
  @current_nav = 3 if params[:id]=='1'
  @nav = erb :nav
  erb :site_page
end

get "/user/:id" do 
  user = User.find(params[:id])
  @introduction = Maruku.new(user.introduction).to_html
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
