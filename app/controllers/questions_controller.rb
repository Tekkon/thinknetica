class QuestionsController < ApplicationController
  include Voted
  include Commented

  respond_to :js

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: :show
  after_action :publish_question, only: :create

  def index
    respond_with(@questions = Question.all)
  end

  def show
    gon.question_user_id = @question.user_id
    gon.question_id = @question.id
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    respond_with(@question = Question.create(question_params))
  end

  def update
    respond_with @question.update(question_params) if is_question_author?
  end

  def destroy
    respond_with @question.destroy if is_question_author?
  end

  private

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      { question: @question, rating: @question.rating, user_id: current_user.id }
    )
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def interpolation_options
    { resource_name: 'Your question' }
  end

  def is_question_author?
    is_author = current_user.author_of?(@question)
    flash[:notice] = 'You can update or delete only your questions.' unless is_author
    is_author
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file]).merge(user: current_user)
  end
end
