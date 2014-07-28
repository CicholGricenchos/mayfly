Mayfly::Admin.controllers :site_configs do
  get :index do
    @title = "Site_configs"
    @site_configs = SiteConfig.all
    render 'site_configs/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'site_config')
    @site_config = SiteConfig.new
    render 'site_configs/new'
  end

  post :create do
    @site_config = SiteConfig.new(params[:site_config])
    if @site_config.save
      @title = pat(:create_title, :model => "site_config #{@site_config.id}")
      flash[:success] = pat(:create_success, :model => 'SiteConfig')
      params[:save_and_continue] ? redirect(url(:site_configs, :index)) : redirect(url(:site_configs, :edit, :id => @site_config.id))
    else
      @title = pat(:create_title, :model => 'site_config')
      flash.now[:error] = pat(:create_error, :model => 'site_config')
      render 'site_configs/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "site_config #{params[:id]}")
    @site_config = SiteConfig.find(params[:id])
    if @site_config
      render 'site_configs/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'site_config', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "site_config #{params[:id]}")
    @site_config = SiteConfig.find(params[:id])
    if @site_config
      if @site_config.update_attributes(params[:site_config])
        flash[:success] = pat(:update_success, :model => 'Site_config', :id =>  "#{params[:id]}")

        SiteConfig.fetch

        params[:save_and_continue] ?
          redirect(url(:site_configs, :index)) :
          redirect(url(:site_configs, :edit, :id => @site_config.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'site_config')
        render 'site_configs/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'site_config', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Site_configs"
    site_config = SiteConfig.find(params[:id])
    if site_config
      if site_config.destroy
        flash[:success] = pat(:delete_success, :model => 'Site_config', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'site_config')
      end
      redirect url(:site_configs, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'site_config', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Site_configs"
    unless params[:site_config_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'site_config')
      redirect(url(:site_configs, :index))
    end
    ids = params[:site_config_ids].split(',').map(&:strip)
    site_configs = SiteConfig.find(ids)
    
    if SiteConfig.destroy site_configs
    
      flash[:success] = pat(:destroy_many_success, :model => 'Site_configs', :ids => "#{ids.to_sentence}")
    end
    redirect url(:site_configs, :index)
  end
end
