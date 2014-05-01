DonbikiProject::Admin.controllers :dtweets do
  get :index do
    @title = "Dtweets"
    @dtweets = Dtweet.all
    render 'dtweets/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'dtweet')
    @dtweet = Dtweet.new
    render 'dtweets/new'
  end

  post :create do
    @dtweet = Dtweet.new(params[:dtweet])
    if @dtweet.save
      @title = pat(:create_title, :model => "dtweet #{@dtweet.id}")
      flash[:success] = pat(:create_success, :model => 'Dtweet')
      params[:save_and_continue] ? redirect(url(:dtweets, :index)) : redirect(url(:dtweets, :edit, :id => @dtweet.id))
    else
      @title = pat(:create_title, :model => 'dtweet')
      flash.now[:error] = pat(:create_error, :model => 'dtweet')
      render 'dtweets/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "dtweet #{params[:id]}")
    @dtweet = Dtweet.find(params[:id])
    if @dtweet
      render 'dtweets/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'dtweet', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "dtweet #{params[:id]}")
    @dtweet = Dtweet.find(params[:id])
    if @dtweet
      if @dtweet.update_attributes(params[:dtweet])
        flash[:success] = pat(:update_success, :model => 'Dtweet', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:dtweets, :index)) :
          redirect(url(:dtweets, :edit, :id => @dtweet.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'dtweet')
        render 'dtweets/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'dtweet', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Dtweets"
    dtweet = Dtweet.find(params[:id])
    if dtweet
      if dtweet.destroy
        flash[:success] = pat(:delete_success, :model => 'Dtweet', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'dtweet')
      end
      redirect url(:dtweets, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'dtweet', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Dtweets"
    unless params[:dtweet_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'dtweet')
      redirect(url(:dtweets, :index))
    end
    ids = params[:dtweet_ids].split(',').map(&:strip)
    dtweets = Dtweet.find(ids)
    
    if Dtweet.destroy dtweets
    
      flash[:success] = pat(:destroy_many_success, :model => 'Dtweets', :ids => "#{ids.to_sentence}")
    end
    redirect url(:dtweets, :index)
  end
end
