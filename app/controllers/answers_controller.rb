class AnswersController < ApplicationController
  respond_to :html, :js

  before_action :authenticate_user!
  before_action :find_question, only: [:new, :create]

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
      redirect_to question_path(@answer.question)
    else
      flash[:notice] = 'You can delete only yours answers.'
      render 'questions/show'
    end
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @question = @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
