DonbikiProject::App.controllers :user do
  get ':user'  do
      @user = User.joins(:dtweet).find_by(:name=>params[:user]) 
    puts @user
    render 'user/user' 
  end
end
