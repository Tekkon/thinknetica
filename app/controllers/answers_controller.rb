class AnswersController < ApplicationController
  before_action :find_question, only: [:new, :create]

  def new
    @answer = @question.answers.build
  end

  def create
  	@answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to question_path(@question)
    else
      render :new
    end
  end

  private

  def answer_params
  	params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end