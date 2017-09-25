require_relative '../features_helper'

feature 'User can browse a list of questions', %q{
  In order to get a list of questions
  As an user
  I want to be able to browse a list of questions
} do

  given(:questions) { create_list(:question, 2, user: create(:user)) }

  scenario 'User browses a list of questions' do
    questions
    visit questions_path

    questions.each do |q|
      expect(page).to have_content(q.title)
    end
  end

end

feature 'User can browse a question and its answers', %q{
  In order to browse a list of answers
  As an user
  I want to be able to browse a question and its answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answers) { create_list(:answer, 2, question: question, user: user) }

  scenario 'User browses a question and its answers' do
    answers
    visit question_path question

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |a|
      expect(page).to have_content a.body
    end
  end

end
