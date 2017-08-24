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

    if @answer.favorite
      @question.answers.where("id != #{@answer.id}").each do |a|
        a.update(favorite: false)
      end
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :favorite)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
