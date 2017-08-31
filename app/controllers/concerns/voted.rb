module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:vote, :revote]
  end

  def vote
    respond_to do |format|
      format.json do
        if current_user.author_of?(@votable)
          render json: { error: "Author can't vote his question or answer." }
        elsif @votable.vote(current_user)
          render json: { error: "You have alredy voted." }
        else
          @vote = @votable.vote!(current_user, params[:vote_type])
          render json: { vote: @vote, html: render_to_string(partial: 'shared/vote_result', layout: false, formats: :html, locals: { votable: @votable }) }
        end
      end
    end
  end

  def revote
    respond_to do |format|
      format.json do
        @vote = @votable.vote(current_user)

        if @vote
          @votable.revote!(current_user)
          render json: { vote: @vote,
                         html: render_to_string(partial: 'shared/vote_buttons', layout: false, formats: :html, locals: { votable: @votable, votable_type: @vote.votable_type }) }
        else
          render json: { error: 'Only the author of the vote can delete it.' }
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
