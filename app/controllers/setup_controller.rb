class SetupController < ApplicationController
  def new
#    @user = User.new
#    @blog = Blog.new
  end

  def create
    @user = User.new params.require(:user).permit(:name, :email, :password, :password_confirmation)
    @blog = Blog.new params.require(:blog).permit(:title, :baseurl)
    if @user.save
      flash[:success] = "User successfully created."
    else
    end
    if @blog.save
    else
    end
    render 'new'
  end

end
