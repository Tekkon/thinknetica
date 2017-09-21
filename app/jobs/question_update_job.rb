class QuestionUpdateJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Subscription.find_each.each do |s|
      DailyMailer.question_update(s.user, answer).deliver_later
    end
  end
end
