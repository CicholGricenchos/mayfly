Mayfly::App.controllers :category do
  before do 
    @categories = Category.all
  end

  get :index, :with => :id do 
    @nav = 'design' if params[:id]=='1'
    @page = params[:page].nil? ? 1 : params[:page].to_i
    @max_page= Article.where(:category_id => params[:id]).count / 8 + 1
    @articles = Article.order("id DESC").where(:category_id => params[:id]).limit(7).offset((@page-1)*7)
    render :index
  end
end
