
get "/admin/login" do 
  erb :'admin/login'
end

post "/admin/login" do 
  user = User.where(:name => params[:name])[0]
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
  if session[:user_id]==1
    comment = ""
    ArticleComment.order("id DESC").all.each do |x| 
      comment += "#{x.author} // #{x.content} // #{x.created_at} @ article #{x.article_id} <br />"
    end
    @content = comment 
    erb :'admin/admin'
  end
end

get "/admin/database" do 
  if session[:user_id]==1
    FileUtils.cp("development.sqlite3","./public")
    @content = "数据库已就位。<br /> <a href=\"../development.sqlite3\">点击下载</a>"
    erb :'admin/admin'
  end
end

get "/article/:id/edit" do redirect to "/admin/edit/#{params[:id]}" end

get "/admin/edit/:id" do 
  if session[:user_id]==1
    article = Article.find(params[:id])
    @id = article.id
    @title = article.title
    @category = article.category
    @author = article.author
    @brief = article.brief
    @content = article.content
    @target = "#{$SITE_URL}/admin/edit/#{params[:id]}"
    @content = erb :'admin/edit'
    erb :'admin/admin'
  end
end

post "/admin/edit/:id" do 
  if session[:user_id]==1
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
end

get "/admin/new/article" do 
  if session[:user_id]==1
    @target = "$SITE_URL/new/article"
    @content = erb :'admin/edit'
    erb :'admin/admin'
  end
end

post "/admin/new/article" do 
  if session[:user_id]==1
    Article.create(:title => params[:title], :category => params[:category].to_i, :author => params[:author].to_i, :brief => params[:brief], :content => params[:content])
    @content = "新文章添加完成"
    erb :'admin/admin'
  end
end