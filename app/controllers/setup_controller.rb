class SetupController < ApplicationController
  def new
    @show_setup = show_setup?
  end

  def create
    @user = User.new params.require(:user).permit(:name, :email, :password, :password_confirmation)
    @blog = Blog.new params.require(:blog).permit(:title, :baseurl)
    User.transaction do 
      @user.save!
      @blog.save!
      flash[:success] = "User successfully created."
      redirect_to 'new'
    end
  rescue
    @blog.valid?
    render 'new'
  end

  private

  def show_setup?
    return true if User.all == nil or User.all.empty?
  end

end
