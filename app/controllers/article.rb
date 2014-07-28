#encoding : utf-8

Mayfly::App.controllers :article do
  before do 
    @categories = Category.all
  end

  get :index, :with => :id do 
    @nav = 'about' if params[:id]=='9'
    @article = Article.find(params[:id])
    @page_title = "#{$SITE_CONFIG[:site_title]} - #{@article.title}"
    @meta_description = @article.brief
    render :index
  end

  post :create_comment, :map => '/article/:id/comment' do
    ArticleComment.create(:article_id => params[:id].to_i, :content => params[:content].gsub(/<\/?.*?>/,""), :author => params[:name].gsub(/<\/?.*?>/,""))
    redirect to("/article/#{params[:id]}")
  end
  

end
