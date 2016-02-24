class ArticlesController < ApplicationController
#  before_action :signed_in_user, only: [:new, :create, :edit, :update, :drafts, :destroy]
  before_action :signed_in_user, except: [:index, :show, :showbyurl]

  def new
    @article = Article.new
    @medium = Medium.new
    @blogs = Blog.all
  end

  def home
  end

  def index
    blog_id = get_blog_id()
    # index shows all articles belongs to specific blog_id and status: published regardless users
    articles = Article.where(blog_id: blog_id).published.paginate(page: params[:page], :per_page => 3)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink:true, tables:true)
    @articles = articles.each do |article|
      article.url =  individual_url article
      article.content = markdown.render article.content
    end
  end

  def drafts
#    blog_id = get_blog_id()
#    articles = Article.where(blog_id: blog_id).draft.paginate(page: params[:page], :per_page => 3)
    # Drafts only shows draft articles belongs to current_user
    articles = current_user.articles.draft.paginate(page: params[:page], :per_page => 3)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink:true, tables:true)
    @articles = articles.each do |article|
      article.url =  individual_url article
      article.content = markdown.render article.content
    end
  end

  def create
    @article = current_user.articles.build article_params

    if @article.published? # || params[:status] == :published 
      @article.published_at = Time.now unless @article.published_at
    end

    if @article.save
      flash[:success] = "Article saved."
      redirect_to @article
    else
      flash[:danger] = "Article could not be saved."
      @medium = Medium.new ### better way to keep @medium object in view??
      render 'new'
    end
  end

  def edit
#    @article = Article.find_by_alt_url params[:alt_url]
    @article = Article.find params[:id] 
    @medium = Medium.new #######
    @blogs = Blog.all
    render 'edit'
  end

  def update
    @article = Article.find params[:id] 

    if @article.update_attributes article_params

      if @article.published?
        @article.update_attribute(:published_at, Time.now) unless @article.published_at
      end

      flash[:success] = "Article Updated"
      redirect_to @article
    else
      flash[:error] = "Article could not be updated"
      render 'edit'
    end
  end

  def showbyurl
    @article = Article.find_by_alt_url params[:alt_url]
    @article = Article.find params[:alt_url] unless @article
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autlink: true, tables: true)
    @article.content = markdown.render @article.content
    render 'show'
  end

  def show
    @article = Article.find params[:id]
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autlink: true, tables: true)
    @article.content = markdown.render @article.content
  end

  private

  def individual_url article
#    base_url = 'http://zero.init.org:3000/articles/'
    base_url = Blog.find(get_blog_id).baseurl + '/articles/'
    article.alt_url ? base_url + article.alt_url : base_url + article.id.to_s
  end

  def article_params
    params.require(:article).permit(:title, :content, :alt_url, :status, :tag_list, :blog_id)
  end

  def signed_in_user
    redirect_to signin_url, notice: "please sign in." unless signed_in?
  end
  
  def get_blog_id
    # requrl = request.original_url
    request_blog = Blog.where("baseurl like ?", "%#{request.host}%").first # revisit/fix later if request.host is appropriate identifier for Blog.
    
#    request_blog = Blog.find_by(:id => 1) ##### temporary for testing
    request_blog ? request_blog.id : 1  # return default ID as fallback. revisit/fix later..
  end

end

