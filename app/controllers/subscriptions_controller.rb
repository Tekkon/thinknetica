class SubscriptionsController < ApplicationController
  before_action :load_question, only: :create
  before_action :load_subscription, only: :destroy

  def create
    if current_user.subscriber_of?(@question)
      render json: { error: "You are alredy subscribed!" }, status: :unprocessable_entity
    else
      render json: (@subscription = Subscription.create(question_id: params[:question_id], user: current_user))
    end
  end

  def destroy
    if current_user.subscriber_of?(@subscription.question)
      @subscription.destroy
      render json: :nothing
    else
      render json: { error: "You can delete only yours subscription!" }, status: :unprocessable_entity
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_subscription
    @subscription = Subscription.find(params[:id])
  end
end
