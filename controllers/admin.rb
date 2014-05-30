#encoding : utf-8

#require 'digest'

get "/admin/login" do 
  erb :'admin/login'
end

get "/admin/logout" do 
  session[:user_id] = -1
  erb :'admin/login'
end

post "/admin/login" do 
  user = User.where(:name => params[:name])[0]
#  if user.password == Digest::MD5.hexdigest(Digest::MD5.hexdigest(params[:pass]))
  if user.password == params[:pass]
    session[:user_id] = user.id
    return "<a href=\"../admin\"> #{user.name}，欢迎回来。</a>"
  else
    return "用户名/密码错误"
  end
end

get "/admin" do 
  redirect to "/admin/login" if session[:user_id]!=1
  @content = "管理员 Cichol"
  erb :'admin/admin'
end

get "/admin/comment" do 
  return if session[:user_id]!=1
  comment = ""
  ArticleComment.order("id DESC").limit(30).each do |x| 
    @comment_id = x.id
    @comment_author = x.author
    @comment_content = x.content
    @comment_time = x.created_at.getlocal
    comment += erb :'admin/comment'
  end
  @content = comment 
  erb :'admin/admin'
end

get "/admin/delete/comment/:id" do 
  return if session[:user_id]!=1
  ArticleComment.delete(params[:id].to_i)
  @content = "删除完成"
  erb :'admin/admin'
end

get "/admin/database" do 
  return if session[:user_id]!=1
  FileUtils.cp("development.sqlite3","./public")
  @content = "数据库已就位。<br /> <a href=\"../development.sqlite3\">点击下载</a>"
  Thread.new do 
    sleep 60
    FileUtils.rm("./public/development.sqlite3")
  end
  erb :'admin/admin'
end

get "/admin/category" do 
  return if session[:user_id]!=1
  @content = ""
  category = Category.all
  category.each do |x|
    @category_id = x.id
    @category_name = x.name
    @content += erb :'admin/category'
  end
  @category_id = 'new'
  @category_name = '新分类'
  @content += erb :'admin/category'
  erb :'admin/admin'
end

post "/admin/category/:id" do 
  return if session[:user_id]!=1
  if params[:id]=='new' 
    Category.create(:name => params[:name])
  else
    c = Category.find(params[:id].to_i)
    c.name = params[:name]
    c.save
  end
  @content = "修改完成"
  erb :'admin/admin'
end

get "/article/:id/edit" do redirect to "/admin/edit/#{params[:id]}" end

get "/admin/edit/:id" do 
  return if session[:user_id]!=1
  article = Article.find(params[:id])
  @id = article.id
  @title = article.title
  @category = article.category
  @author = article.author
  @brief = article.brief
  @content = article.content
  @target = "#{$SITE_URL}/admin/edit/#{params[:id]}"
  @content = erb :'admin/editor'
  erb :'admin/admin'
end

post "/admin/edit/:id" do 
  return if session[:user_id]!=1
  article = Article.find(params[:id])
  article.title = params[:title]
  article.category = params[:category].to_i
  article.author = params[:author].to_i
  article.brief = params[:brief]
  article.content = params[:content]
  article.save
  @content = "修改完成"
  erb :'admin/admin'
end

get "/admin/new/article" do 
  return if session[:user_id]!=1
  @target = "#{$SITE_URL}/new/article"
  @content = erb :'admin/editor'
  erb :'admin/admin'
end

post "/admin/new/article" do 
  return if session[:user_id]!=1
  Article.create(:title => params[:title], :category => params[:category].to_i, :author => params[:author].to_i, :brief => params[:brief], :content => params[:content])
  @content = "新文章添加完成"
  erb :'admin/admin'
end

get "/admin/delete/article/:id" do 
  return if session[:user_id]!=1
  Article.delete(params[:id].to_i)
  @content = "删除完成"
  erb :'admin/admin'
end

get "/admin/site_config" do 
  return if session[:user_id]!=1
  @site_title = SiteConfig.where(:name => 'site_title')[0].value
  @site_description = SiteConfig.where(:name => 'site_description')[0].value
  @site_footer = SiteConfig.where(:name => 'site_footer')[0].value
  @meta_description = SiteConfig.where(:name => 'meta_description')[0].value
  @meta_keywords = SiteConfig.where(:name => 'meta_keywords')[0].value
  @content = erb :'admin/site_config'
  erb :'admin/admin'
end

post "/admin/site_config" do 
  return if session[:user_id]!=1
  ['site_title','site_description','site_footer','meta_description','meta_keywords'].each do |x|
    s = SiteConfig.where(:name => x)[0]
    s.value = params[x.to_sym]
    s.save
  end
  @content = "修改完成"
  erb :'admin/admin'
end
