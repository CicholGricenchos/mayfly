Mayfly::App.controllers :base do
  get :index, :map=>'/' do 
    @nav = 'index'
    @categories = Category.all
    @page = params[:page].nil? ? 1 : params[:page].to_i
    @max_page= Article.where("category_id != 4").count / 8 + 1
    @articles = Article.order("id DESC").where("category_id != 4").limit(7).offset((@page-1)*7)
    render :index
  end

end
