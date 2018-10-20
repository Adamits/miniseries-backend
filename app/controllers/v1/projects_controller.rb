class V1::ProjectsController < ApplicationController
  respond_to :json

  def index
    paginate json: Project.all
  end

  def show
    render json: Project.find(params[:id])
  end
end
