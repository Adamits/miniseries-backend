class V1::TagsController < ApplicationController
  respond_to :json

  def index
    paginate json: Tag.all
  end

  def show
    render json: Tag.find(params[:id])
  end
end
