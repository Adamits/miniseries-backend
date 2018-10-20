class V1::Account::ProjectsController < V1::AccountController
  respond_to :json

  def index
    paginate json: current_user.projects
  end

  def show
    render json: project
  end

  def edit
    render json: project
  end

  def update
    project.update_attributes(project_params)
    render json: project
  end

  def create
    project = current_user.projects.new(project_params)
    if project.save
      render json: {success: true}
    else
      render json: {success: false, errors: project.errors.full_messages, status: 400}
    end
  end

  def destroy
    render json: project.destroy
  end

  private
  def project
    @project ||= current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description)
  end
end
