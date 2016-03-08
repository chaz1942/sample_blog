SampleBlog::Admin.controllers :posts do
  get :index do
    @title = "Posts"
    post_data = Post.all
    p1 = Post.first
    b=Set.new
    post_data.each do |i|
      if i.account == current_account
        b.add(i)
      end
    end
    @posts = b
    render 'posts/index'
  end
  
  get :test do
  markdownString = "# sample_blog\r\nrealize a simple blogs with padrino\r\n##requirement description\r\n\tusing padrino establish a simleple blogs,it has some function point as follow:\r\n\t1.index page is article list, click open the page;\r\n\t2.account function: User can register their account(Email,passport and nickname)\r\n\t3.blogs manager:User can add new article and delete their blogs.\r\n\t4.blogs show can display markdown grammar."
  p markdownString
  doc = Maruku.new(markdownString)
  @data = doc.to_html_document
  end

  get :new do
    @title = pat(:new_title, :model => 'post')
    @post = Post.new
    render 'posts/new'
  end

  post :create do
    @post = Post.new(params[:post])
    @post.account = current_account
    if @post.save
      flash[:notice] = '恭喜，博文已成功创建！'
      redirect url(:posts, :edit, :id => @post.id)
    else
      render 'posts/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "post #{params[:id]}")
    @post = Post.find(params[:id])
    p @post
    p current_account
    if @post
      if @post.account_id == current_account.id
        render 'posts/edit'
      else
        redirect url(:posts, :index)
      end
      
    else
      flash[:warning] = pat(:create_error, :model => 'post', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "post #{params[:id]}")
    @post = Post.find(params[:id])
    if @post
      if @post.update_attributes(params[:post])
        flash[:success] = pat(:update_success, :model => 'Post', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:posts, :index)) :
          redirect(url(:posts, :edit, :id => @post.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'post')
        render 'posts/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'post', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Posts"
    post = Post.find(params[:id])
    if post.account_id == current_account.id
      if post.destroy
        flash[:success] = pat(:delete_success, :model => 'Post', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'post')
      end
      redirect url(:posts, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'post', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Posts"
    unless params[:post_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'post')
      redirect(url(:posts, :index))
    end
    ids = params[:post_ids].split(',').map(&:strip)
    posts = Post.find(ids)
    
    if Post.destroy posts
    
      flash[:success] = pat(:destroy_many_success, :model => 'Posts', :ids => "#{ids.join(', ')}")
    end
    redirect url(:posts, :index)
  end
  def fillter(post)
    b = Set.new()
    post.each do |i|
      if i.account_id == current_account
        p i
        b.add(i)
      end
    end
    return b
  end
end
