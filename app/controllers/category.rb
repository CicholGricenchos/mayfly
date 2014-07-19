#encoding : utf-8

Mayfly::App.controllers :category do
  before do 
    @categories = Category.all
  end

  get :index, :with => :id do 
    @nav = 'design' if params[:id]=='1'
    @page = params[:page].nil? ? 1 : params[:page].to_i
    @category = Category.find(params[:id])
    @max_page = @category.articles.count / 8 + 1
    @articles = @category.articles.order("id DESC").where(:category_id => params[:id]).limit(7).offset((@page-1)*7)
    @page_title = "蜉蝣人文爱好小组 - #{@category.name}"
    render :index
  end
end
