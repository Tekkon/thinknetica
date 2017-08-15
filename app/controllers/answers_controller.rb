class AnswersController < ApplicationController
  before_action :authenticate_user!, excpet: :new
  before_action :find_question, only: [:new, :create]

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id

    flash[:notice] = 'Your answer is created successfully.' if @answer.save

    redirect_to question_path(@question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
