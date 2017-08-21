require_relative 'features_helper'

feature 'User can delete his answer', %q{
  In order to delete my answers
  As an user
  I want to be able to delete my answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user tries to delete his answer' do
    sign_in(user)
    answer
    visit question_path(question)
    click_on 'Delete this answer'

    expect(page).to_not have_content answer.body
    expect(page).to have_content 'Your answer is deleted successfully.'
  end

  scenario 'Authenticated user tries to delete another\'s answer' do
    sign_in(user)

    another_user = create(:user)
    create(:question, user_id: another_user.id)
    create(:answer, question_id: question.id, user_id: another_user.id)
    visit question_path(question)

    expect(page).to_not have_content 'Delete this answer'
  end

  scenario 'Non-authenticated user tries to delete an answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete this answer'
  end

end
