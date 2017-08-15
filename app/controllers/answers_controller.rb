class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :new
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

  def destroy
    @answer = Answer.find(params[:id])

    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer is deleted successfully.'
    else
      flash[:notice] = 'You can delete only yours answers.'
    end

    redirect_to question_path(@answer.question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
