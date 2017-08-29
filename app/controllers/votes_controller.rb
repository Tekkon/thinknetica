class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_votable, only: [:create]

  def create
    @vote = Vote.new(vote_params)
    @vote.user = current_user

    respond_to do |format|
      format.json do
        if current_user.author_of?(@votable)
          render json: { error: "Author can't vote his question or answer." }
        else
          if @vote.save
            render json: @vote
          else
            render json: { error: @vote.errors.full_messages.join(',') }
          end
        end
      end
    end
  end

  private

  def load_votable
    @votable = params[:votable_type].classify.constantize.find(params[:votable_id]) if params[:votable_type].present?
  end

  def vote_params
    params.permit(:votable_id, :votable_type, :vote_type)
  end
end
