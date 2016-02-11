class ArticlesController < ApplicationController
  def new
    @article = Article.new
    @medium = Medium.new
  end

  def home
  end

  def index
    articles = Article.paginate(page: params[:page], :per_page => 3)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink:true, tables:true)
    @articles = articles.each do |article|
      article.url =  individual_url article
      article.content = markdown.render article.content
    end
  end
 
  def create
    article_params = params.require(:article).permit(:title, :content, :alt_url)
    @article = current_user.articles.build article_params
    if @article.save
      flash[:success] = "Article saved."
      redirect_to @article
    else
      flash[:error] = "Article could not be saved."
      render 'new'
    end
  end

  def edit
    @article = Article.find_by_alt_url params[:alt_url]
    @article = Article.find params[:alt_url] unless @article
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
    base_url = 'http://zero.init.org:3000/articles/'
    article.alt_url ? base_url + article.alt_url : base_url + article.id.to_s
  end
end
