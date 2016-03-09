SampleBlog::Admin.controllers :accounts do
  get :index do
    @title = "Accounts"
    b = Set.new
    allAccount = Account.all
    allAccount.each do |i|
      if i.id == current_account.id
        b.add(i)
      end
    end
    @accounts = b
    render 'accounts/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'account')
    p @title
    @account = Account.new
    p @account
    render 'accounts/new'
  end

  post :create do
    @account = Account.new(params[:account])
    if @account.save
      @title = pat(:create_title, :model => "account #{@account.id}")
      flash[:success] = pat(:create_success, :model => 'Account')
      params[:save_and_continue] ? redirect(url(:accounts, :index)) : redirect(url(:accounts, :edit, :id => @account.id))
    else
      @title = pat(:create_title, :model => 'account')
      flash.now[:error] = pat(:create_error, :model => 'account')
      render 'accounts/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "account #{params[:id]}")
    @account = Account.find(params[:id])
    if @account
      if @account.id == current_account.id
        render 'accounts/edit'
      else
        halt 404
      end
      
    else
      flash[:warning] = pat(:create_error, :model => 'account', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "account #{params[:id]}")
    @account = Account.find(params[:id])
    if @account
      if @account.update_attributes(params[:account])
        flash[:success] = pat(:update_success, :model => 'Account', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:accounts, :index)) :
          redirect(url(:accounts, :edit, :id => @account.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'account')
        render 'accounts/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'account', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    halt 404
  end

  delete :destroy_many do
    halt 404
  end
end
