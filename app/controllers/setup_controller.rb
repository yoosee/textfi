class SetupController < ApplicationController
  def new
    @user = User.new
    @blog = Blog.new
  end

  def create
  end

end
