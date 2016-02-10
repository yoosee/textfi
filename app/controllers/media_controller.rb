class MediaController < ApplicationController
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
  end

  def show
  end

  private
  def medium_params
    params.require(:medium).permit(:image)
#    params.permit(:image)
  end

end
