class V1::AuthorsController < ApplicationController
  respond_to :json

  def index
    paginate json: User.where('compositions_count > 0')
  end

  def show
    user = User.find(params[:id])
    render json: user
  end
end
