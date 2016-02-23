class BlogsController < ApplicationController
  def new
    @blog = Blog.new
  end


end
