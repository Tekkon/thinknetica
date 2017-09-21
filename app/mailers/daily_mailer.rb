class DailyMailer < ApplicationMailer
  default from: 'thinknetica-dev@example.com'

  def digest(user)
    @questions = Question.where('created_at > ?', (Time.now - 1.day).strftime('%Y-%m-%d'))

    mail to: user.email
  end

  def question_update(user, answer)
    @answer = answer

    mail to: user.email
  end
end
