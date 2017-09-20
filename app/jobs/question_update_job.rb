class QuestionUpdateJob < ApplicationJob
  queue_as :default

  def perform(user, answer)
    DailyMailer.question_update(user, answer).deliver_later
  end
end
