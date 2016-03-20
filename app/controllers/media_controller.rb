class MediaController < ApplicationController
  before_action :signed_in_user, except: [:show]

  def new
    @medium = Medium.new
  end

  def create
    @medium = Medium.create medium_params

    if @medium.save
      render json: { message: "success", fileID: @medium.id }, :status => 200
    else
      render json: { error: @medium.erros.full_messages.join(',') }, :status => 400
    end
  end

  def index
    @media = Medium.reorder("created_at DESC").paginate(page: params[:page], :per_page => 24)
  end

  def show
    @medium = Medium.find params[:id]
  end

  def destroy
    @medium = Medium.find params[:id]
    begin
      @medium.image = nil
      @medium.save
      @medium.destroy
    rescue
      flash[:danger] = "unable to delete medium #{@medium.errors.full_messages.join(',')}"
      render json: { message: @medium.errors.full_messages.join(',') }
    else
      flash[:success] = "Medium deleted"
      render json: { message: "Medium deleted" }
    end
    redirect_to :back
  end


  private
  def medium_params
    params.require(:medium).permit(:image)
  end

  def signed_in_user
    redirect_to signin_url, notice: "please sign in." unless signed_in?
  end

end
