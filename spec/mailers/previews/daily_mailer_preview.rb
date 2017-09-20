# Preview all emails at http://localhost:3000/rails/mailers/daily_mailer
class DailyMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/daily_mailer/digest
  def digest
    DailyMailer.digest(User.first)
  end

  # Preview this email at http://localhost:3000/rails/mailers/daily_mailer/question_update
  def question_update
    DailyMailer.question_update(User.first, Question.first.answers.first)
  end

end
