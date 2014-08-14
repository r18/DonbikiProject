DonbikiProject::Admin.controllers :turntweets do
  get :index do
    @title = "Turntweets"
    @turntweets = Turntweet.all
    render 'turntweets/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'turntweet')
    @turntweet = Turntweet.new
    render 'turntweets/new'
  end

  post :create do
    @turntweet = Turntweet.new(params[:turntweet])
    if @turntweet.save
      @title = pat(:create_title, :model => "turntweet #{@turntweet.id}")
      flash[:success] = pat(:create_success, :model => 'Turntweet')
      params[:save_and_continue] ? redirect(url(:turntweets, :index)) : redirect(url(:turntweets, :edit, :id => @turntweet.id))
    else
      @title = pat(:create_title, :model => 'turntweet')
      flash.now[:error] = pat(:create_error, :model => 'turntweet')
      render 'turntweets/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "turntweet #{params[:id]}")
    @turntweet = Turntweet.find(params[:id])
    if @turntweet
      render 'turntweets/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'turntweet', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "turntweet #{params[:id]}")
    @turntweet = Turntweet.find(params[:id])
    if @turntweet
      if @turntweet.update_attributes(params[:turntweet])
        flash[:success] = pat(:update_success, :model => 'Turntweet', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:turntweets, :index)) :
          redirect(url(:turntweets, :edit, :id => @turntweet.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'turntweet')
        render 'turntweets/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'turntweet', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Turntweets"
    turntweet = Turntweet.find(params[:id])
    if turntweet
      if turntweet.destroy
        flash[:success] = pat(:delete_success, :model => 'Turntweet', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'turntweet')
      end
      redirect url(:turntweets, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'turntweet', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Turntweets"
    unless params[:turntweet_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'turntweet')
      redirect(url(:turntweets, :index))
    end
    ids = params[:turntweet_ids].split(',').map(&:strip)
    turntweets = Turntweet.find(ids)
    
    if Turntweet.destroy turntweets
    
      flash[:success] = pat(:destroy_many_success, :model => 'Turntweets', :ids => "#{ids.to_sentence}")
    end
    redirect url(:turntweets, :index)
  end
end
