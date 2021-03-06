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
    @posts=Post.all(:order => 'created_at desc')
    render 'posts/index'
  end

  get :show do
    @getPost = Post.find_by_id(params[:id])
    postsBody = @getPost.body
    htmlCode = (Maruku.new(postsBody)).to_html_document
    splitsHtmlCode = htmlCode.split("title>");
    len = splitsHtmlCode[0].length
    httphead = splitsHtmlCode[0].slice(0,len-1)
    titleContent = "<title>#{@getPost.title}</title><h1 style=\"text-align:center\">#{@getPost.title}</h1>"
    httptail = splitsHtmlCode[2]
    @posts = httphead + titleContent + httptail
  end
end
