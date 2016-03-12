SampleBlog::App.controllers :posts do
  
  # get :index, :map => '/foo/bar' do
  #   session[:foo] = 'bar'
  #   render 'index'
  # end

  # get :sample, :map => '/sample/url', :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  # get '/example' do
  #   'Hello world!'
  # end
  get :index do
    if $account != nil
      @login_name = "welcome, " + $account.surname
    else
      @login_name = "login/register"
    end
    @posts=Post.all(:order => 'created_at desc')
    render 'posts/index'
  end

  get :show do
    @getPost = Post.find_by_id(params[:id])
    postsBody = @getPost.body
    markdowndisplay = (Maruku.new(postsBody)).to_html
    @title = @getPost.title
    @posts = markdowndisplay
    render "/posts/show"
  end


end
