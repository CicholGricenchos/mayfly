#encoding : utf-8

require 'sinatra'
require 'sinatra/activerecord'
require 'maruku'
require './models/article'
require './models/user'
require './models/category'
require './models/article_comment'
require './models/site_config'
require './controllers/admin'

$SITE_URL = "http://localhost:4567"

#set :database, {adapter: "sqlite3", database: "development.sqlite3"}
#set :database, {:adapter => 'mysql2', :host => 'localhost', :database => "mayfly", :username => 'root', :password => 'freedom'}
set :database, {adapter: "mysql2", database: "Cichol-mysql-4KhVRuzc", username: "AVc8Un16", password: "EsWM78a86GVq", host: "10.0.16.16", port: 4066}

ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter.class_eval do
  def begin_db_transaction
    execute "SET AUTOCOMMIT=0"
  rescue
  end

  def commit_db_transaction #:nodoc:
    execute "COMMIT"
    execute "SET AUTOCOMMIT=1"
  rescue
    # Transactions aren't supported
  end

  def rollback_db_transaction #:nodoc:
    execute "ROLLBACK"
    execute "SET AUTOCOMMIT=1"
  rescue
    # Transactions aren't supported
  end
end

enable :sessions

before do
  @site_title = SiteConfig.where(:name => 'site_title')[0].value
  @site_description = SiteConfig.where(:name => 'site_description')[0].value
  @site_footer = SiteConfig.where(:name => 'site_footer')[0].value
end

get '/' do
  @page = params[:page].nil? ? 1 : params[:page].to_i
  @max_page= Article.count / 7 + 1
  @page_title = @site_title
  articles = Article.order("id DESC").where("category != 4").limit(7).offset((@page-1)*7)
  @content = ""
  articles.each do |x|
    @id = x.id
    @brief = x.brief
    @title = x.title
    @date = x.created_at.getlocal.strftime("%Y-%m-%d  %H:%M")
    @author = User.find(x.author).name
    @author_id = x.author
    @category = Category.find(x.category).name
    @category_id = x.category
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
  @meta_description = SiteConfig.where(:name => 'meta_description')[0].value
  @meta_keywords = SiteConfig.where(:name => 'meta_keywords')[0].value
  @page_bar = erb :page_bar
  erb :site_page
end

get "/article/:id" do 
  article = Article.find(params[:id])
  @content = Maruku.new(article.content).to_html
  @title = article.title
  @date = article.created_at.getlocal.strftime("%Y-%m-%d  %H:%M")
  @brief = article.brief
  @author = User.find(article.author).name
  @author_id = article.author
  @category = Category.find(article.category).name
  @category_id = article.category
  @page_title = "#{@site_title} - #{@title}"
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
    @comment_time = x.created_at.getlocal.strftime("%Y-%m-%d  %H:%M")
    @comment_content = x.content 
    @comment += erb :comment 
  end
  @current_nav = 2 if params[:id]=='9'
  @nav = erb :nav
  @article_id = params[:id]
  @comment_form = erb :comment_form
  @meta_description = @brief
  erb :site_page
end

get "/category/:id" do 
  @page = params[:page].nil? ? 1 : params[:page].to_i
  @max_page= Article.where(:category => params[:id].to_i).count / 7 + 1
  @name = Category.find(params[:id].to_i).name
  @page_title = "#{@site_title} - #{@name}"
  articles = Article.where(:category => params[:id].to_i).order("id DESC").limit(7).offset((@page-1)*7)
  @content = ""
  articles.each do |x|
    @id = x.id
    @brief = x.brief
    @title = x.title
    @date = x.created_at.getlocal.strftime("%Y-%m-%d  %H:%M")
    @author = User.find(x.author).name
    @author_id = x.author
    @category = Category.find(x.category).name
    @category_id = x.category
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
  @page_bar = erb :page_bar
  erb :site_page
end

get "/user/:id" do 
  user = User.find(params[:id])
  @introduction = Maruku.new(user.introduction).to_html
  @name = user.name
  @page_title = "#{@site_title} - #{@name}"
  @content = erb :user
  @category_list = ""
  categories = Category.where("id != 4").all
  categories.each do |x|
    @category_id = x.id
    @category_name = x.name
    @category_list += erb :category_list
  end
  @nav = erb :nav
  erb :site_page
end

post "/article_comment/:id" do 
  if session[:last_comment].nil? || Time.now.to_i-session[:last_comment] > 60
    ArticleComment.create(:article_id => params[:id].to_i, :content => params[:content].gsub(/<\/?.*?>/,""), :author => params[:name].gsub(/<\/?.*?>/,""))
    session[:last_comment] = Time.now.to_i
    redirect to("/article/#{params[:id]}")
  else
    @page_title = @site_title
    @nav = erb :nav
    @category_list = ""
    categories = Category.where("id != 4").all
    categories.each do |x|
      @category_id = x.id
      @category_name = x.name
      @category_list += erb :category_list
    end
    @content = "请等候60s再进行评论。"
    erb :site_page
  end
end
