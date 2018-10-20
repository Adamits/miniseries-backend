class V1::Account::TagsController < V1::AccountController
  respond_to :json

  def index
    paginate json: current_user.tags
  end

  def show
    render json: tag
  end

  def edit
    render json: tag
  end

  def update
    tag.update_attributes(tag_params)
    render json: tag
  end

  def create
    tag = current_user.tags.new(tag_params)
    if tag.save
      render json: {success: true}
    else
      render json: {success: false, errors: tag.errors.full_messages, status: 400}
    end
  end

  def destroy
    render json: tag.destroy
  end

  private
  def tag
    @tag ||= current_user.tags.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name, :description)
  end
end
