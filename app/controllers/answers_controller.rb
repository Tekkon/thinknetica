class AnswersController < ApplicationController
  before_action :authenticate_user!, excpet: :new
  before_action :find_question, only: [:new, :create]

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      flash[:notice] = 'Your answer is created successfully.'
    end

    redirect_to question_path(@question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :user_id)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
