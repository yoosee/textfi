class BlogsController < ApplicationController
  before_action :signed_in_user
  def new
    @blog = Blog.new
  end

  def index
    @blogs = Blog.all
  end

  def create
    @blog = Blog.new blog_params
    if @blog.save
      flash[:success] = "New Blog Created"
    else
      flash[:danger] = "New Blog could not be created."
      render 'new'
    end
    render 'index'
  end

  def edit
    @blog = Blog.find params[:id]
    render 'edit'
  end

  def update
    @blog = Blog.find params[:id]
    if @blog.update_attributes blog_params
      flash[:success] = "Blog updated"
      render 'edit'
    else
      flash[:danger] = "Blog update failed"
      render 'edit'
    end
  end

  private
  def blog_params
    params.require(:blog).permit(:title, :baseurl, :summary)
  end

end
