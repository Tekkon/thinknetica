require 'rails_helper'

feature 'User can browse a list of questions', %q{
  In order to get a list of questions
  As an user
  I want to be able to browse a list of questions
} do

  given(:question) { create(:question, user: create(:user)) }

  scenario 'User browses a list of questions' do
    visit questions_path question

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
  end

end

feature 'User can browse a question and its answers', %q{
  In order to browse a list of answers
  As an user
  I want to be able to browse a question and its answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'User browses a question and its answers' do
    answer = create(:answer, question: question, user: user)

    visit question_path question

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end

end