class AnswersController < ApplicationController
  include Voted

  respond_to :html, :js

  before_action :authenticate_user!
  before_action :find_question, only: [:new, :create]
  after_action :publish_answer, only: [:create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    @answer.save
  end

  def destroy
    @answer = Answer.find(params[:id])

    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer is deleted successfully.'
    else
      flash[:notice] = 'You can delete only yours answers.'
    end
  end

  def update
    @answer = Answer.find(params[:id])
    @question = @answer.question

    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    else
      flash[:notice] = 'You can update only your answers.'
    end
  end

  def mark_favorite
    @answer = Answer.find(params[:id])
    @question = @answer.question

    if current_user.author_of?(@question)
      @answer.mark_favorite
    else
      flash[:notice] = 'Only the author of the question can choose favorite answer.'
    end
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
        'answers',
        { answer: @answer.as_json(include: { attachments: { methods: :filename } }), question: @question, rating: @answer.rating, user_id: current_user.id }
    )
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
