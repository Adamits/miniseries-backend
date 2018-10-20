class V1::Account::Writers::Projects::CompositionsController < V1::AccountController
  before_action :authorize_project

  def show
    render json: composition
  end

  def edit
    render json: composition
  end

  def update
    composition.update_attributes(composition_params)
    render json: composition
  end

  def create
    composition = @project.compositions.build(composition_params)
    composition.user = current_user
    composition.save
    render json: composition
  end

  private
  def composition
    @composition ||= @project.compositions.find(params[:id])
  end

  def authorize_project
    @project = current_user.projects.where(id: params[:project_id]).last

    if !@project
      redirect_to account_settings_path
    end
  end

  def composition_params
    params.require(:composition).permit(:title, :description, :content, :published)
  end
end
