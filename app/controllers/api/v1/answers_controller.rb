class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  before_action :find_question, only: [:index, :create]

  def index
    @answers = @question.answers
    respond_with @answers.order(:id)
  end

  def show
    respond_with Answer.find(params[:id])
  end

  def create
    @answer = @question.answers.create(answer_params)
    respond_with(:api, :v1, @answer)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body).merge(user: current_resource_owner)
  end
end
