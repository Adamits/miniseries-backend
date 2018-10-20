class V1::CompositionsController < ApplicationController
  respond_to :json
  before_action :authenticate_v1_user!, only: ["vote", "tag"]

  def index
    paginate json: Composition.all
  end

  def show
    render json: Composition.find(params[:id])
  end

  def vote
    composition = Composition.find(params[:id])
    vote_type = map_vote_type(params[:vote_type])
    render json: current_user.cast_vote(vote_type, composition)
  end

  def tag
    composition = Composition.find(params[:id])
    tag = Tag.find(params[:tag_id])
    render json: current_user.tag(
                    tag, composition, params[:start_span],
                    params[:end_span], content=params[:content]
                  )
  end

  private
  def map_vote_type(vote_type)
    h = {
          positive: "Vote::Positive",
          negative: "Vote::Negative"
        }

    h.with_indifferent_access[vote_type]
  end
end
