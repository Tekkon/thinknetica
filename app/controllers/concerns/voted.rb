module Voted
  extend ActiveSupport::Concern

  included do
    respond_to :json, only: [:vote_for, :vote_against, :revote]
    before_action :load_votable, only: [:vote_for, :vote_against, :revote]
  end

  def vote_for
    respond_to do |format|
      format.json do
        if current_user.author_of?(@votable)
          render json: { error: "Author can't vote his question or answer." }, status: :unprocessable_entity
        elsif @votable.vote_by(current_user)
          render json: { error: "You have alredy voted." }, status: :unprocessable_entity
        else
          @vote = @votable.vote!(current_user, 1)
          render json: { vote: @vote, rating: @votable.rating }
        end
      end
    end
  end

  def vote_against
    respond_to do |format|
      format.json do
        if current_user.author_of?(@votable)
          render json: { error: "Author can't vote his question or answer." }, status: :unprocessable_entity
        elsif @votable.vote_by(current_user)
          render json: { error: "You have alredy voted." }, status: :unprocessable_entity
        else
          @vote = @votable.vote!(current_user, -1)
          render json: { vote: @vote, rating: @votable.rating }
        end
      end
    end
  end

  def revote
    respond_to do |format|
      format.json do
        @vote = @votable.vote_by(current_user)

        if @vote
          @votable.revote!(current_user)
          render json: { vote: @vote, votable: @votable, rating: @votable.rating }
        else
          render json: { error: 'Only the author of the vote can delete it.' }, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_votable
    @votable = model_klass.find(params[:id])
  end
end
