#encoding : utf-8

Mayfly::App.controllers :base do
  get :index, :map=>'/' do 
    @nav = 'index'
    @categories = Category.all
    @page = params[:page].nil? ? 1 : params[:page].to_i
    @max_page= Article.where("category_id != 4").count / 8 + 1
    @articles = Article.order("id DESC").where("category_id != 4").limit(7).offset((@page-1)*7)
    @page_title = "蜉蝣人文爱好小组"
    @meta_description = "致力于改善高校校园人文环境，社会人文的观察者，热诚的实践者。"
    @meta_keywords = "蜉蝣,人文,哲学,社会,教育"
    render :index
  end

end
