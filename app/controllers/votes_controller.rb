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
            render json: { vote: @vote, html: render_to_string(partial: 'shared/vote_result', layout: false, formats: :html, locals: { votable: @vote.votable }) }
          else
            render json: { error: @vote.errors.full_messages.join(',') }
          end
        end
      end
    end
  end

  def destroy
    @vote = Vote.find(params[:id])

    respond_to do |format|
      format.json do
        if current_user.author_of?(@vote)
          @vote.destroy
          render json: { vote: @vote,
                         html: render_to_string(partial: 'shared/vote_buttons', layout: false, formats: :html, locals: { votable: @vote.votable, votable_type: @vote.votable_type }) }
        else
          render json: { error: 'Only the author of the vote can delete it.' }
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
