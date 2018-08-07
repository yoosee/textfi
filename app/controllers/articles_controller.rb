class ArticlesController < ApplicationController
  before_action :signed_in_user, except: [:index, :rss, :show, :showbyurl]
  before_action :set_blog

  def new
    @article = Article.new
    @medium = Medium.new
    @blogs = Blog.all
  end

  def home
  end

  def index
    # index shows all articles belongs to specific blog_id and status: published regardless users
    articles = Article.where(blog_id: @blog.id).unscoped.published.order("published_at DESC").paginate(page: params[:page], :per_page => 5)
    @articles = articles.each do |article|
      article.content = markdown article.content
    end
  end
  
  def rss
    # rss shows first 10 articles belongs to specific blog_id and status: published regardless users
    articles = Article.where(blog_id: @blog.id).unscoped.published.order("published_at DESC").first(10)
    @articles = articles.each do |article|
      article.content = markdown article.content
    end
    @author = User.find(1)
    render 'rss.xml.erb'
  end

  def drafts
    # Drafts shows draft articles belongs to current_user
    articles = current_user.articles.unscoped.draft.order("updated_at DESC").paginate(page: params[:page], :per_page => 10)
    @articles = articles.each do |article|
      article.content = markdown article.content
    end
  end

  def create
    @article = current_user.articles.build article_params

    # add published_at time at the first published timing
    if @article.published?
      @article.published_at = Time.now unless @article.published_at
    end

    if @article.save
      flash[:success] = "Article saved."
      redirect_to @article.url
    else
      flash[:danger] = "Article could not be saved."
      @medium = Medium.new ### better way to keep @medium object in view??
      @blogs = Blog.all
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
      # add published_at time at the first published timing
      if @article.published?
        @article.update_attribute(:published_at, Time.now) unless @article.published_at
      end
      flash[:success] = "Article Updated"
      redirect_to @article.url
    else
      flash[:error] = "Article could not be updated"
      render 'edit'
    end
  end

  def destroy
    @article = Article.find params[:id]
    id = @article.id
    title = @article.title
    if @article.destroy
      flash[:success] = "Article ID:#{id} \"#{title}\" Deleted"
      redirect_to articles_drafts_path
    else
      flash[:danger] = "Article ID:#{id} \"#{title}\" Deleted"
      redirect_to articles_drafts_path
    end
  end

  def showbyurl
    @article = Article.find_by_alt_url params[:alt_url]
    @article = Article.find params[:alt_url] unless @article
    @article.content = markdown @article.content
    @article.summary_image = make_summary_image @article.content, @blog.baseurl
    @article.summary_content = make_summary_content @article.content
    @article.similar_tagged =  get_similar_tagged @article
    render 'show'
  end

  def show
    @article = Article.find params[:id]
    @article.content = markdown @article.content
    make_summary @article.content
  end

  def tagged
    ### Toto: it might be need limit by blog.id
    @articles = Article.tagged_with(params[:tags]).published.paginate(page: params[:page], :per_page => 10)
    if @articles.empty?
      flash[:warning] = "Articles Tagged \"#{params[:tags]}\" Not found."
    else
      flash[:success] = "Articles Tagged \"#{params[:tags]}\" found."
    end
    render 'tagged'
  end

#  private

  def article_params
    params.require(:article).permit(:title, :content, :alt_url, :status, :tag_list, :blog_id)
  end

  def signed_in_user
    redirect_to signin_url, notice: "please sign in." unless signed_in?
  end

  def set_blog
    blog_id = get_blog_id 
    begin
      @blog = Blog.find blog_id
    rescue => e
      flash[:error] = "Blog doesn't exist. Please setup your Blog."
      redirect_to '/setup'
      return
    end
    @blog.summary = markdown @blog.summary.gsub(/'/,"\'")
  end
  
  def get_blog_id
    # requrl = request.original_url
    request_blog = Blog.where("baseurl like ?", "%#{request.host}%").first # revisit/fix later if request.host is appropriate identifier for Blog.
    request_blog ? request_blog.id : 1  # return default ID as fallback. revisit/fix later..
  end

  def get_similar_tagged article, num = 4
    # try match_all tags first, then any of if not hit.
    tagged_articles = Array.new;
    Article.tagged_with(article.tag_list, match_all: true).order("published_at DESC").published.limit(num+1).each do |a|
      if a.id != article.id # exclude self
        content = markdown a.content
        a.summary_image = make_summary_image content, @blog.baseurl
        a.summary_content = make_summary_content content
        tagged_articles.push a 
      end
    end
    if tagged_articles.size < num 
      # .limit is actually .limit(num+1 - tagged_articles.size + tagged_articles.size since :any includes :match_all
      Article.tagged_with(article.tag_list, any: true).order("published_at DESC").published.limit(num +1).each do |a| 
        if a.id != article.id # exclude self
          content = markdown a.content
          a.summary_image = make_summary_image content, @blog.baseurl
          a.summary_content = make_summary_content content
          tagged_articles.push a 
        end
      end
    end
    tagged_articles.uniq
  end

  # capture first img in HTML and set it to summary image for Social share.
  def make_summary_image html, base_url
    doc = Nokogiri::HTML.parse html
    begin 
      summary_image = doc.css('img').first.attribute('src').to_s
    rescue
      summary_image = nil
    end
    summary_image = '' unless summary_image
    if summary_image && !summary_image.empty? && /^http/ !~ summary_image
      summary_image = "#{base_url}/#{summary_image}"
    end
    summary_image
  end

  def make_summary_content html
    doc = Nokogiri::HTML.parse html
    begin 
      doc.css('p').first.inner_text
    rescue
      ''
    end
  end

  def markdown text
    render_options = {
      hard_wrap: true,
      filter_html: false,
      with_toc_data: true,
      prettify: true
    }
    extensions = {
      no_intra_emphasis: true,
      autolink: true,
      tables: true,
      superscript: true,
      fenced_code_blocks: true,
      disable_indented_code_blocks: true,
      footnotes: true
    }
    markdown = Redcarpet::Markdown.new(TextfiMarkdown.new(render_options), extensions)
    markdown.render(text).html_safe
  end
end

