Mayfly::Admin.controllers :article_comments do
  get :index do
    @title = "Article_comments"
    @article_comments = ArticleComment.all
    render 'article_comments/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'article_comment')
    @article_comment = ArticleComment.new
    render 'article_comments/new'
  end

  post :create do
    @article_comment = ArticleComment.new(params[:article_comment])
    if @article_comment.save
      @title = pat(:create_title, :model => "article_comment #{@article_comment.id}")
      flash[:success] = pat(:create_success, :model => 'ArticleComment')
      params[:save_and_continue] ? redirect(url(:article_comments, :index)) : redirect(url(:article_comments, :edit, :id => @article_comment.id))
    else
      @title = pat(:create_title, :model => 'article_comment')
      flash.now[:error] = pat(:create_error, :model => 'article_comment')
      render 'article_comments/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "article_comment #{params[:id]}")
    @article_comment = ArticleComment.find(params[:id])
    if @article_comment
      render 'article_comments/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'article_comment', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "article_comment #{params[:id]}")
    @article_comment = ArticleComment.find(params[:id])
    if @article_comment
      if @article_comment.update_attributes(params[:article_comment])
        flash[:success] = pat(:update_success, :model => 'Article_comment', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:article_comments, :index)) :
          redirect(url(:article_comments, :edit, :id => @article_comment.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'article_comment')
        render 'article_comments/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'article_comment', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Article_comments"
    article_comment = ArticleComment.find(params[:id])
    if article_comment
      if article_comment.destroy
        flash[:success] = pat(:delete_success, :model => 'Article_comment', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'article_comment')
      end
      redirect url(:article_comments, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'article_comment', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Article_comments"
    unless params[:article_comment_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'article_comment')
      redirect(url(:article_comments, :index))
    end
    ids = params[:article_comment_ids].split(',').map(&:strip)
    article_comments = ArticleComment.find(ids)
    
    if ArticleComment.destroy article_comments
    
      flash[:success] = pat(:destroy_many_success, :model => 'Article_comments', :ids => "#{ids.to_sentence}")
    end
    redirect url(:article_comments, :index)
  end
end
