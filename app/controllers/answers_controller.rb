class AnswersController < ApplicationController
  include Voted
  include Commented

  respond_to :js

  before_action :authenticate_user!
  before_action :find_question, only: [:new, :create]
  before_action :load_answer, only: [:update, :destroy, :mark_favorite]
  after_action :publish_answer, only: :create

  def create
    respond_with(@answer = @question.answers.create(answer_params))
  end

  def destroy
    respond_with @answer.destroy if is_answer_author?
  end

  def update
    respond_with @answer.update(answer_params) if is_answer_author?
  end

  def mark_favorite
    is_question_author = current_user.author_of?(@question)
    flash[:notice] = 'Only the author of the question can choose favorite answer.' unless is_question_author
    respond_with @answer.mark_favorite if is_question_author
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "question_#{@question.id}",
      { answer: @answer.as_json(include: { attachments: { methods: :filename } }), question: @question, rating: @answer.rating, user_id: current_user.id }
    )
  end

  def is_answer_author?
    is_author = current_user.author_of?(@answer)
    flash[:notice] = 'You can update or delete only your answers.' unless is_author
    is_author
  end

  def load_answer
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file]).merge(user: current_user)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
