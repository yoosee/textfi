class MediumController < ApplicationController
  def new
    @media = Medium.new
  end

  def create
    @media = Medium.create media_params
    if @media.save
      render json: { message: "success" }, :status => 200
    else
      render json: { error: @media.erros.full_messages.join(',') }, :status => 400
    end
  end

  def index
  end

  def show
  end

  private
  def media_params
    params.require(:media).permit(:image)
  end

end
