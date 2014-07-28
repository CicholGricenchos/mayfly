#encoding : utf-8

Mayfly::App.controllers :base do
  get :index, :map=>'/' do 
    @nav = 'index'
    @categories = Category.all
    @page = params[:page].nil? ? 1 : params[:page].to_i
    @max_page= Article.where("visible = 1").count / 8 + 1
    @articles = Article.order("id DESC").where("visible = 1").limit(7).offset((@page-1)*7)
    @page_title = $SITE_CONFIG[:site_title]
    @meta_description = $SITE_CONFIG[:meta_description]
    @meta_keywords = $SITE_CONFIG[:meta_keywords]
    render :index
  end

end
